# Exploratory Data Analysis and Regression Analysis of yield as a function of other variables

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.api as sm

# Load the data
df = pd.read_csv('joined.csv')

# Exploratory Data Analysis
print(df.head())
print(df.describe())
print(df.info())
