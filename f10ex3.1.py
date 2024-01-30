# -*- coding: utf-8 -*-
"""
Created on Thu Dec 12 10:54:12 2019

@author: Tiago
"""

import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder

from keras.models import Sequential
from keras.layers import Dense, Activation
from keras.optimizers import Adam


iris_data = load_iris()

x = iris_data.data
y_column = iris_data.target.reshape(-1,1)

encoder = OneHotEncoder(sparse=False)
y=encoder.fit_transform(y_column)

print("Example data:")
print(x[np.array([0,50,100]), :])

print("Example labels:")
print(y_column[np.array([0,50,100]), :])


model = Sequential([
 Dense(32, input_shape=(784,)),Activation('relu'),
 Dense(10), Activation('softmax'),
])
 
model = Sequential()
model.add(Dense(32, input_dim=784))
model.add(Activation('relu'))

model.summary()
