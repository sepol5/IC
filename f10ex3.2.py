# -*- coding: utf-8 -*-
"""
Created on Thu Dec 12 11:34:24 2019

@author: Tiago
"""

import tensorflow as tf

mnist = tf.keras.datasets.mnist

(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train, x_test = x_train / 255.0, x_test / 255.0

# Instancia uma rede “Densa” em tf.Keras:

model = tf.keras.models.Sequential([
 tf.keras.layers.Flatten(input_shape=(28, 28)),
 tf.keras.layers.Dense(128, activation='relu'),
 tf.keras.layers.Dropout(0.2),
 tf.keras.layers.Dense(10, activation='softmax')
])

model.compile(optimizer='adam',
 loss='sparse_categorical_crossentropy',
 metrics=['accuracy'])

#Treina a rede
model.fit(x_train, y_train, epochs=10)

#Avalia para dados de teste
model.evaluate(x_test, y_test, verbose=2)