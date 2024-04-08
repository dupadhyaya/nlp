import pandas as pd
from pydataset import data
import matplotlib.pyplot as plt


mtcars = data('mtcars')
mtcars.describe()
mtcars.head()

mtcars.mpg.plot(kind='hist')
plt.show()
