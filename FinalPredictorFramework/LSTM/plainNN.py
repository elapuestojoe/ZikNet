from pandas import read_csv, DataFrame, concat
from sklearn.preprocessing import LabelEncoder, MinMaxScaler, RobustScaler, StandardScaler
from keras import Sequential
from keras.layers import LSTM, Dense, Dropout, TimeDistributed, BatchNormalization
from keras.regularizers import l2
from keras.constraints import nonneg
from matplotlib import pyplot
from numpy import concatenate
from math import sqrt
from sklearn.metrics import mean_squared_error
from keras.models import model_from_json
from os.path import isfile
import numpy as np 
modelName = "modelPlain"
# population = 8112505 #DEBUG VERACRUZ
# population = 15203934 #DEBUG BAHIA
population = 5189970 #DEBUG NUEVO LEON

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

# dataset = read_csv('data/Weekly-Veracruz_15-11-2015_848.csv', header=0, index_col=1)
# dataset = read_csv('data/Weekly-Bahia_04-01-2015_504.csv', header=0, index_col=1) # DEBUG
dataset = read_csv('data/Weekly-NuevoLeon_15-11-2015_848.csv', header=0, index_col=1)
# dataset.drop(["coordinates", "precipProbability", "precipIntensity", "precipIntensityMax"], axis=1, inplace=True)
# dataset.drop(["coordinates"], axis=1, inplace=True)
dataset.drop(["coordinates", "precipProbability", "precipIntensity", "precipIntensityMax", "temperatureLow", "temperatureHigh", "humidity"], axis=1, inplace=True)


# ToDo: Normalize/Scale each column 

featureScaler = MinMaxScaler(feature_range=(0, 1))
# dataset[["temperatureHigh", "temperatureLow", "humidity", "searches"]] = \
# 	featureScaler.fit_transform(dataset[["temperatureHigh", "temperatureLow", "humidity", "searches"]])

dataset[["searches"]] = featureScaler.fit_transform(dataset[["searches"]])

#yearNumber stays the same

#Try converting cases to cases per 100K 
dataset[["cases"]] = dataset[["cases"]].apply(lambda x: x*100000/population, axis=1)

# outputScaler = RobustScaler()
# outputScaler = StandardScaler()
# dataset[["cases"]] = outputScaler.fit_transform(dataset[["cases"]])

values = dataset.values
# ensure all data is float
values = values.astype('float32')

total_features = len(values[0])

#Set number of lag weeks
n_weeks = 3
# n_features = 6
n_features = 3

# Convert to supervised learning
reframed = series_to_supervised(values, n_weeks, 1)
print("Reframed Shape: ", reframed.shape) #Returns an array with shape (n, 32) 32 = 8 features per week and 4 weeks

# split into train and test sets
values = reframed.values
n_train_weeks = int(reframed.shape[0]*0.2) #ToDo - use a generator  #DEBUG
print("Using {} train hours".format(n_train_weeks))
train = values[:n_train_weeks, :]
test = values [n_train_weeks:, :]

train_X, train_y = train[:, :-1], train[:, -1] #takes t-i weeks and t observations except from the last one (cases)
test_X, test_y = test[:, :-1], test[:, -1]
print(train_X.shape, len(train_X), train_y.shape)

model = None

if(isfile("{}.json".format(modelName)) and isfile("{}.h5".format(modelName))):
	json_file = open("{}.json".format(modelName), "r")
	loaded_model_json = json_file.read()
	json_file.close()
	model = model_from_json(loaded_model_json)

	# load weights
	model.load_weights("{}.h5".format(modelName))
	model.compile(loss="mse", optimizer="adam")
	print("Loaded model from disk")

	#Make predictions on test data
	yhat = model.predict(test_X)

	# print("PRED", yhat)
	test_y = test_y.reshape((len(test_y), 1))
	# print("TESTY", test_y)

	inv_yhat = np.apply_along_axis(lambda x: x * population / 100000, 1, yhat) #Revert to actual cases
	inv_testY = np.apply_along_axis(lambda x: x * population / 100000, 1, test_y) #Revert to actual cases

	# calculate RMSE
	rmse = sqrt(mean_squared_error(inv_testY, inv_yhat))
	print('Test RMSE: %.3f' % rmse)
	print("Total", sum(inv_testY))
	print("len", len(inv_testY))
	print("REAL", inv_testY)
	print("Predicted: ", inv_yhat)

	pyplot.plot(inv_testY)
	pyplot.plot(inv_yhat)
	pyplot.show()

else:
	print("SHAPE", train_X.shape)
	#Set network 
	model = Sequential()
	model.add(Dense(128, input_shape=(train_X.shape[1],), activation="relu"))
	# model.add(Dropout(0.25))
	model.add(Dense(64, activation="relu"))
	model.add(Dense(1, activation='linear', kernel_constraint=nonneg())) 
	# model.add(Dense(1, activation="relu")) #DEBUG

	model.compile(loss="mse", optimizer="adam", metrics=["mse"])
	history = model.fit(train_X, train_y, epochs = 30, batch_size=32, validation_data=(test_X, test_y), verbose=2, shuffle=True)

	#Save model 
	model_json = model.to_json()
	with open("{}.json".format(modelName), "w") as json_file:
		json_file.write(model_json)
	#seralize weights to HDF5
	model.save_weights("{}.h5".format(modelName))
	print("Saved model to disk")

	# plot history

	if("loss" in history.history):
		pyplot.plot(history.history['loss'], label='train')

	if("val_loss" in history.history):
		pyplot.plot(history.history['val_loss'], label='test')

	if("mean_squared_error" in history.history):
		pyplot.plot(history.history["mean_squared_error"], label="mse")

	if("val_mean_squared_error" in history.history):
		pyplot.plot(history.history["val_mean_squared_error"], label="val_mse")

	pyplot.legend()
	pyplot.show()