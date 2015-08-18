# Analysis of Browser Usage (Python)

# prepare for Python version 3x features and functions
from __future__ import division, print_function

# import packages for data analysis 
import pandas as pd  # data structures for time series analysis
import datetime  # date manipulation
import matplotlib.pyplot as plt

# browser usage data from StatCounter Global Stats
# retrieved from the World Wide Web, October 21, 2014: 
# \url{http://gs.statcounter.com/#browser-ww-monthly-200807-201410
# read in comma-delimited text file 
browser_usage = pd.read_csv('browser_usage_2008_2014.csv')

# examine the data frame object
print(browser_usage.shape)
print(browser_usage.head())

# identify date fields as dates with apply and lambda function
browser_usage['Date'] = \
    browser_usage['Date']\
    .apply(lambda d: datetime.datetime.strptime(str(d), '%Y-%m'))

# define Other category
browser_usage['Other'] = 100 -\
    browser_usage['IE'] - browser_usage['Chrome'] -\
    browser_usage['Firefox'] - browser_usage['Safari'] 

# examine selected columns the data frame object
selected_browser_usage = pd.DataFrame(browser_usage,\
    columns = ['Date', 'IE', 'Chrome', 'Firefox', 'Safari', 'Other'])
print(selected_browser_usage.shape)
print(selected_browser_usage.head())

# create multiple time series plot
selected_browser_usage.plot(subplots = True,  \
     sharex = True, sharey = True, style = 'k-')
plt.legend(loc = 'best')
plt.xlabel('')
plt.savefig('fig_browser_mts_Python.pdf', 
    bbox_inches = 'tight', dpi=None, facecolor='w', edgecolor='b', 
    orientation='portrait', papertype=None, format=None, 
    transparent=True, pad_inches=0.25, frameon=None)  

# Suggestions for the student:
# Explore alternative visualizations of these data.
# Try the Python package ggplot to reproduce R graphics.
# Explore time series for other software and systems.



