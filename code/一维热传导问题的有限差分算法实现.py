# -*- coding: utf-8 -*-
"""
Created on Thu Mar 28 15:29:07 2019

@author: 2016750622戴国政
"""

import numpy as np
import scipy.sparse as ss
import matplotlib.pyplot as plt
import math as math
from matplotlib import cm 
from mpl_toolkits.mplot3d import Axes3D 




def initial(m,n):
    h = (R-L)/m
    g = T/n
    x = np.linspace(L,R,m+1)
    t = np.linspace(0,T,n+1)
    return h,g,x,t
def init_solution(x):
    u0 = np.sin(2*np.pi*x)
    return u0
def turesolve(x,t):
    u = np.sin(2*np.pi*x)*np.exp(10*t)
    return u
def youduanf(x,t):
    f = (10+4*a*(math.pi)**2)*np.sin(2*np.pi*x)*np.exp(10*t)
    return f

def solve_xt(m,n):
    h,g,x,t=initial(m,n)
    r = g/h/h
    
    u0 = init_solution(x)
    
    
    A0 = [1-2*r]*(m-1)
    A0.append(1)
    A0.insert(0,1)
    col0 = list(range(m+1))
    row0 = list(range(m+1))
    A_0 = ss.coo_matrix((A0,(row0,col0)),shape = (m+1,m+1)) 
    
    A1 = [r]*(m-1)
    row1 = list(range(1,m))
    col1 = list(range(m-1))
    A_1 = ss.coo_matrix((A1,(row1,col1)),shape = (m+1,m+1)) 
    
    A2 = [r]*(m-1)
    row2 = list(range(1,m))
    col2 = list(range(2,m+1))
    A_2 = ss.coo_matrix((A2,(row2,col2)),shape = (m+1,m+1)) 
    
    A = A_1+A_2+A_0
    A = A.toarray()
    
    Z = np.zeros((m+1,n+1))
    Z = Z.T
    Z[0]=u0
    
    
    for i in range(1,n+1):
        f = youduanf(x,t[i-1])
        u1 = np.dot(A,u0) + g*f
        Z[i:] = u1
        u0 = u1
    return Z



#误差函数的范数
a = 1
R = 1
L = 0
T = 0.1


for i in range(5):
    m = 10*pow(2,i)
    n = 100*pow(4,i)
    Z = solve_xt(m,n)
    u = np.zeros((m+1,n+1))
    h,g,x,t = initial(m,n)
    for i in range(m+1):
        for j in range(n+1):
            u[i,j] = turesolve(x[i],t[j])
    
    u = u.T
    e = Z- u
    ee = abs(e)
    print (np.max(ee))


#print(u)




