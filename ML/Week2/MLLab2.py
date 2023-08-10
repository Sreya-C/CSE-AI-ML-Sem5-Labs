#!/usr/bin/env python
# coding: utf-8

# ## Solved Examples

# In[95]:


import matplotlib.pyplot as plt
x = [5,2,4,9,7] # x-axis values
y = [10,5,8,4,2] # y-axis values
plt.plot(x,y)
plt.xlabel("X-Axis")
plt.ylabel("Y-Axis")
plt.title("Sample Line Graph")


# In[96]:


x = [5,2,4,9,7] # x-axis values
y = [10,5,8,4,2] # y-axis values
plt.bar(x,y)
plt.title("Sample Bar Graph")


# In[97]:


import matplotlib.pyplot as plt
import numpy as np
x = np.random.normal(170, 10, 250)
plt.hist(x)
plt.show()


# In[98]:


y = [10, 5, 8, 4, 2]
# Function to plot histogram
plt.hist(y)


# In[99]:


x = [5, 2, 9, 4, 7]
y = [10, 5, 8, 4, 2]
plt.scatter(x, y)
plt.show()


# In[100]:


from scipy import constants
print(constants.peta) #1000000000000000.0
print(constants.tera) #1000000000000.0
print(constants.giga) #1000000000.0
print(constants.mega) #1000000.0
print(constants.kilo)


# In[101]:


import numpy as np
from scipy.sparse import csr_matrix
arr = np.array([0, 0, 0, 0, 0, 1, 1, 0, 2])
print(csr_matrix(arr))
print()
arr1 = np.array([[0, 0, 0], [0, 0, 1], [1, 0, 2]])
print(csr_matrix(arr1))
print()
newarr = csr_matrix(arr).tocsc() #Convert CSR - Compressed Sparse Row to CSC - Compressed Sparse Column
print(newarr)


# In[102]:


import pandas as pd
mydataset = { 'cars': ["BMW", "Volvo", "Ford"],
'passings': [3, 7, 2] }
myvar = pd.DataFrame(mydataset)
print(myvar)


# In[103]:


import pandas as pd
new_series= pd.Series([5,6,7,8,9,10],index = ['a','b','c','d','e','f'])
print(new_series)
print()
print(new_series[4])
print()
new_series2= new_series[new_series>7] # check with 7 instead of 0
print(new_series2)
print()
new_series2= new_series[new_series>6] * 2
print(new_series2)


# In[104]:


#DataFrame from a dictionary
import pandas as pd
data = {
"calories": [420, 380, 390],
"duration": [50, 40, 45]
}
#load data into a DataFrame object:
df = pd.DataFrame(data, index = ["day1", "day2", "day3"])
print(df)
print(df.loc['day2'])


# In[105]:


#DataFrame from a list
import pandas as pd
list2=[[0,1,2],[3,4,5],[6,7,8]]
df= pd.DataFrame(list2)
print(df)
df.columns = ['V1','V2','V3']
df.index = ['A','B','C']
print(df)


# In[106]:


import pandas as pd
df=pd.DataFrame({
'Country': ['Kazakhstan','Russia','Belarus','Ukraine'],
'Population': [17.04,143.5,9.5,45.5],
'Square':[2724902, 17125191,207600,603628]
})
df.index = ['KZ','RU','BY','UA']
df.index.name = 'Country Code'
print(df)
print(type(df['Country']))
print(df.iloc[0])
print()
print(df[df.Population > 20][['Country','Square']])
print()


# # QUESTIONS

# In[107]:


import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


# 1. Follow along with these steps:
#     
# a) Create a figure object called fig using plt.figure()
# 
# b) Use add_axes to add an axis to the figure canvas at [0,0,1,1]. Call this new axis ax.
# 
# c) Plot (x,y) on that axes and set the labels and titles to match the plot below:

# In[108]:




fig = plt.figure()
ax = fig.add_axes([0,0,1,1])
x = [0,20,40,60,80,100]
y = [0,50,100,150,200,250]
ax.plot(x,y)
plt.xticks([0,20,40,60,80,100])
plt.yticks([0,50,100,150,200,250])
plt.title("Line Graph")
plt.xlabel("X-AXIS")
plt.ylabel("Y-AXIS")


# 2. Create a figure object and put two axes on it, ax1 and ax2. Located at [0,0,1,1] and [0.2,0.5,.2,.2] respectively. 
# Now plot (x,y) on both axes. And call your figure object to show it.

# In[109]:


fig = plt.figure()
ax1 = fig.add_axes([0,0,1,1])
x = [0,2,5,10,50,250]
y = [0,2,5,10,50,250]
ax1.plot(x,y)
ax2 = fig.add_axes([0.2,0.5,.2,.2])
ax2.plot(x,y)


# Use the company sales dataset csv file, read Total profit of all months and show it using a line plot
# Total profit data provided for each month. Generated line plot must include the following properties: –
#     
#     a. X label name = Month Number
#     
#     b. Y label name = Total profit

# In[116]:


df = pd.read_csv("company_sales_data.csv")
X_ax = df["month_number"]
Y_ax = df["total_profit"]
df.head()
plt.plot(X_ax,Y_ax)
plt.xlabel("Month Number")
plt.ylabel("Total Profit")
plt.title("Total profit data provided for each month.")


# Use the company sales dataset csv file, get total profit of all months and show line plot with the following Style properties. Generated line plot must include following Style properties

# In[123]:


df = pd.read_csv("company_sales_data.csv")
X_ax = df["month_number"]
Y_ax = df["total_units"]
plt.plot(X_ax,Y_ax,marker="o",ls ="dotted",color="r",lw=3,label="Month") #Line Style dotted and Line-color should be red,Add a circle marker,Line width should be 3
plt.title("Total sold units of all months")
plt.xlabel("Month Number") #X label name = Month Number
plt.ylabel("Sold Units") #Y label name = Sold units number
plt.legend(loc = "lower right") # Show legend at the lower right location.


# In[ ]:




