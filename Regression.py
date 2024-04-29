# Exploratory Data Analysis and Regression Analysis of yield as a function of other variables

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.api as sm
from pandasgui import show as tbl

# Load data
ms = pd.read_csv('~/dev/divs/msr.csv')
sds = pd.read_csv('~/dev/divs/sdsr.csv')

# Full outer join the two datasets
df = pd.merge(ms, sds, how='outer', left_on='Tik', right_on='TikS')

# Create a new column 'Ticker' that is equal to 'Tik' if 'Tik' is not null, and 'TikS' otherwise and make it the index
df['Ticker'] = df['Tik'].combine_first(df['TikS'])
df = df.set_index('Ticker')

# Make the 'Yld' column always have value by using 'Yld' if it is not null, and 'YldS' otherwise, 'YldB' otherwise
df['Yld'] = df['Yld'].combine_first(df['YldS'])
df['Yld'] = df['Yld'].combine_first(df['YldB'])

# Change column 'Name' so that it is equal to 'Name' if 'Name' is not null, and 'NameS' otherwise
df['Name'] = df['Name'].combine_first(df['NameS'])

# Delete unnecessary columns
df = df.drop(['Tik', 'TikS', 'YldB', 'YldS', 'YldS', 'NameS', 'Industry', 'SubSect', 'Time', 'Dat', 'Frq', 'Sch'], axis=1)

# Convert 'Yld' to numeric
df['Yld'] = pd.to_numeric(df['Yld'], errors='coerce')

# Replace missing values
df['M'] = df['M'].replace(np.nan, 'None')
df['A'] = df['A'].replace(np.nan, 'Standard')
df['R'] = df['R'].replace(np.nan, 3.0)
df['U'] = df['U'].replace(np.nan, 'Medium')

tbl(df)

# Plot histograms of Yld and kde
plt.figure()
sns.histplot(df['Yld'].dropna(), kde=True, bins=20)
plt.show()
