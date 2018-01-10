from pandas import read_csv, DataFrame, concat
from sklearn.preprocessing import LabelEncoder, MinMaxScaler
from keras import Sequential
from keras.layers import LSTM, Dense
from matplotlib import pyplot
from numpy import concatenate
from math import sqrt
from sklearn.metrics import mean_squared_error
from keras.models import model_from_json
from os.path import isfile


def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):
	n_vars = 1 if type(data) is list else data.shape[1]
	df = DataFrame(data)
	cols, names = list(), list()
	# input sequence (t-n, ... t-1)
	for i in range(n_in, 0, -1):
		cols.append(df.shift(i))
		names += [('var%d(t-%d)' % (j+1, i)) for j in range(n_vars)]
	# forecast sequence (t, t+1, ... t+n)
	for i in range(0, n_out):
		cols.append(df.shift(-i))
		if i == 0:
			names += [('var%d(t)' % (j+1)) for j in range(n_vars)]
		else:
			names += [('var%d(t+%d)' % (j+1, i)) for j in range(n_vars)]
	# put it all together
	agg = concat(cols, axis=1)
	agg.columns = names
	# drop rows with NaN values
	if dropnan:
		agg.dropna(inplace=True)
	return agg

dataset = read_csv('data/Veracruz.csv', header=0, index_col=0)
dataset.drop(["Date"], axis=1, inplace=True)
values = dataset.values
# ensure all data is float
values = values.astype('float32')

# normalize features
scaler = MinMaxScaler(feature_range=(0, 1))
scaled = scaler.fit_transform(values)

n_weeks = 10
n_features = 4
# frame as supervised learning
reframed = series_to_supervised(scaled, 1, 1)
# drop columns we don't want to predict
# reframed.drop(reframed.columns[[5,6,7]], axis=1, inplace=True)

print(reframed.head())

#Define and fit model
#1 year training, 4 years evaluation
# split into train and test sets
values = reframed.values
n_train_hours = 52
train = values[:n_train_hours, :]
test = values[n_train_hours:, :]
# split into input and outputs
train_X, train_y = train[:, :-1], train[:, -1]
test_X, test_y = test[:, :-1], test[:, -1]

# reshape input to be 3D [samples, timesteps, features]
train_X = train_X.reshape((train_X.shape[0], 1, train_X.shape[1]))
test_X = test_X.reshape((test_X.shape[0], 1, test_X.shape[1]))
print(train_X.shape, train_y.shape, test_X.shape, test_y.shape)

model = None
# if(isfile("model.json") and isfile("model.h5")):
if False:
	json_file = open("model.json", "r")
	loaded_model_json = json_file.read()
	json_file.close()
	model = model_from_json(loaded_model_json)

	#load weights
	model.load_weights("model.h5")
	model.compile(loss="mae", optimizer="adam")
	print("Loaded model from disk")
else:

	# design network
	model = Sequential()
	model.add(LSTM(50, input_shape=(train_X.shape[1], train_X.shape[2])))
	model.add(Dense(1))

	model.compile(loss='mae', optimizer='adam')
	# fit network
	history = model.fit(train_X, train_y, epochs=50, batch_size=52, validation_data=(test_X, test_y), verbose=2, shuffle=False)

	#Save model
	model_json = model.to_json()
	with open("model.json", "w") as json_file:
		json_file.write(model_json)
	#seralize weights to HDF5
	model.save_weights("model.h5")
	print("Saved model to disk")

	# plot history
	pyplot.plot(history.history['loss'], label='train')
	pyplot.plot(history.history['val_loss'], label='test')
	pyplot.legend()
	pyplot.show()

#Make predictions
yhat = model.predict(test_X)
test_X = test_X.reshape((test_X.shape[0], test_X.shape[2]))
# invert scaling for forecast
inv_yhat = concatenate((yhat, test_X[:, 1:]), axis=1)
inv_yhat = scaler.inverse_transform(inv_yhat)
inv_yhat = inv_yhat[:,0]
# invert scaling for actual
test_y = test_y.reshape((len(test_y), 1))
inv_y = concatenate((test_y, test_X[:, 1:]), axis=1)
inv_y = scaler.inverse_transform(inv_y)
inv_y = inv_y[:,0]
# calculate RMSE
rmse = sqrt(mean_squared_error(inv_y, inv_yhat))
print('Test RMSE: %.3f' % rmse)

# pyplot.plot(test_X, inv_y, "g--", test_X, inv_yhat, "r--")
# pyplot.show()
print("Actual val", inv_y)
print("LEN", len(inv_y))
print("---")
print("Predicted val", inv_yhat)
print("LEN", len(inv_yhat))

x = []
y = []
pred = []
for i in range(len(inv_y)):
	x.append(i)

pyplot.plot(x, inv_y, x, inv_yhat)
pyplot.show()