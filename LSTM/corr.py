import seaborn as sns
from pandas import read_csv
import matplotlib.pyplot as plt

dataset = read_csv('data/Bahia.csv', header=0, index_col=0)
dataset.drop(["Date"], axis=1, inplace=True)


corr = dataset.corr()
sns.heatmap(corr, 
            xticklabels=corr.columns.values,
            yticklabels=corr.columns.values, 
            annot=True)
plt.show()