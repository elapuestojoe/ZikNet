# from keras.layers.core import Dense, Activation, Dropout
# from keras.layers.recurrent import LSTM
# from keras.models import Sequential
import pandas as pd
from matplotlib import pyplot
from sklearn import preprocessing, metrics
from keras import Sequential, layers
import tensorflow as tf
import os
import numpy as np
import math
# import lstm, time #Helper

dateparse = lambda dates: pd.datetime.strptime(dates, '%d/%m/%Y')
#Cargar datos
rawdata = pd.read_csv("./veracruzModel.csv",
	parse_dates={"timeline": ['Fecha']},
	index_col="timeline",
	date_parser=dateparse)
rawdata.drop("Entidad", axis=1, inplace=True)
rawdata.drop("Altura", axis=1, inplace=True)
rawdata.columns = ["Busquedas","Precipitacion","Temp","Casos"]

# Scatterplot
dataset = rawdata
values = dataset.values
#Plot
groups = [0,1,2,3]
i = 1
pyplot.figure()
for group in groups:
	pyplot.subplot(len(groups),1,i)
	pyplot.plot(values[:,group])
	pyplot.title(dataset.columns[group], y=0.5, loc="right")
	i +=1
# pyplot.show() #Descomentar para ver scatterplot

# El LSTM Forecast multivariate model

#Convertir la serie a supervised learning
# Predecir los casos de la siguiente semana utilizando los casos actuales 
# + las demás variables del paso pasado
def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):
	n_vars = 1 if type(data) is list else data.shape[1]
	df = pd.DataFrame(data)
	cols, names = list(), list()
	# sequencia (t-n, ... t-1)
	for i in range(n_in, 0, -1):
		cols.append(df.shift(i))
		names += [("var%d(t-%d)" % (j+1, i)) for j in range(n_vars)]
	#forecast sequence (t, t+1, ... t+n)
	for i in range(0, n_out):
		cols.append(df.shift(-i))
		if i == 0:
			names += [("var%d(t)" % (j+1)) for j in range(n_vars)]
		else:
			names += [("var%d(t+%d)" % (j+1, i)) for j in range(n_vars)]

	# Juntar todo
	agg = pd.concat(cols, axis=1)
	agg.columns = names
	#drop rows con NA (si hubiera)
	if dropnan:
		agg.dropna(inplace=True)
	return agg

encoder = preprocessing.LabelEncoder()
values[:,3] = encoder.fit_transform(values[:,3])

values = values.astype("float32")

#normalizar predictores
scaler = preprocessing.MinMaxScaler(feature_range=(0,1))
scaled = scaler.fit_transform(values)
# print(dataset)

# print(scaled)
#frame para aprendizaje supervisado (3 semanas previas, una saldia)
reframed = series_to_supervised(scaled, 1, 1)

#eliminar columnas que no queremos predecir
totalRows = reframed.shape[1]
reframed.drop(reframed.columns[[totalRows-4,totalRows-3,totalRows-2]], axis=1, inplace=True)

# print(reframed.head())

# split into train and test sets
values = reframed.values
n_train_weeks = 50
train = values[:n_train_weeks,:]
test = values[n_train_weeks:,:]

train_X, train_y = train[:,:-1], train[:,-1]
test_X, test_y = test[:,:-1], test[:,-1]

train_X = train_X.reshape((train_X.shape[0], 1, train_X.shape[1]))
test_X = test_X.reshape((test_X.shape[0], 1, test_X.shape[1]))

print("Test/train",train_X.shape, train_y.shape, test_X.shape, test_y.shape)

#Diseñar la red
model = Sequential()
model.add(layers.LSTM(50, input_shape=(train_X.shape[1], train_X.shape[2])))
model.add(layers.Dense(1))
model.compile(loss="mae", optimizer="adam")

#fit network
history = model.fit(train_X, train_y, 
	epochs=20, 
	batch_size=35,
	validation_data=(test_X, test_y),
	verbose=2,
	shuffle=False)

#plot history
# pyplot.plot(history.history["loss"], label="train")
# pyplot.plot(history.history["val_loss"], label="test")
# pyplot.legend()
# pyplot.show()

#predict
yhat = model.predict(test_X)
# print(test_X, "initial")
test_X = test_X.reshape((test_X.shape[0], test_X.shape[2]))
# print(test_X, "reshaped")
#invert scaling to forecast

# print(test_X[:,3:]) #Indice de lo que estamos prediciendo
inv_yhat = np.concatenate((yhat,test_X[:, 1:]), axis=1) #Revisar que el índice sea correcto
inv_yhat = scaler.inverse_transform(inv_yhat)
inv_yhat = inv_yhat[:,0]

# #invert scaling for actual
test_y = test_y.reshape((len(test_y), 1))
inv_y = np.concatenate((test_y, test_X[:, 1:]), axis=1)
inv_y = scaler.inverse_transform(inv_y)
inv_y = inv_y[:,0]
# # calculate RMSE

print("INV_Y",inv_y)
print("INV_YHAT", inv_yhat)
rmse = math.sqrt(metrics.mean_squared_error(inv_y, inv_yhat))

# pyplot.subplot(len(groups),1,i)
pyplot.plot(inv_yhat)
pyplot.title("prediccion", y=0.5, loc="right")
pyplot.show()
print('Test RMSE: %.3f' % rmse)