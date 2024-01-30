# -*- coding: utf-8 -*-
"""
Created on Tue Nov  5 15:21:38 2019

@author: Tiago
"""
from sklearn.datasets import load_iris
iris_dataset = load_iris()#carrega dados

print(iris_dataset.keys())#imprime as chaves
print(iris_dataset['target_names'])#imprime as classes
print(iris_dataset['feature_names'])#imprime os nomes
print(iris_dataset['DESCR'])#imprime a descriçao comp

#print(iris_dataset['data'])
#print(iris_dataset['data'].shape)