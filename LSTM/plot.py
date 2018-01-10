from matplotlib import pyplot
from pandas import read_csv
# load dataset
dataset = read_csv('data/Veracruz.csv', header=0, index_col=0)
values = dataset.values
# specify columns to plot
groups = [1, 2, 3, 4]
i = 1
# plot each column
pyplot.figure()
for group in groups:
	pyplot.subplot(len(groups), 1, i)
	pyplot.plot(values[:, group])
	pyplot.title(dataset.columns[group], y=0.5, loc='right')
	i += 1
pyplot.show()