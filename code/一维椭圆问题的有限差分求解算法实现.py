# -*- coding: utf-8 -*-
"""
Created on Tue Mar 19 10:03:15 2019

@author: 戴国政2016750622
"""

import numpy as np
import matplotlib.pyplot as plt
import scipy.sparse as ss
import pandas as pd

#准备工作
def initial(L,R,NS):
    x = np.linspace(L,R,NS+1)
    h = (R-L) / NS
    x = x[1:-1]
    return x,h

def zhenjie_u(x):
    u = (1-x**2)*np.exp(-x**2)
    return u
def youduan_f(x):
    return (4*x**4-15*x**2+5)*np.exp(-x**2)


#解方程
def solve(NS):
    x,h = initial(L,R,NS)
    
    #左端A
    data_1 = [(h**2+2)/h**2]*(NS-1)
    I1 = list(range(NS-1))
    J1 = list(range(NS-1))
    data_2 = [-1/h**2]*(NS-2)
    I2 = list(range(NS-2))
    J2 = list(range(1,NS-1))
    A_1 = ss.coo_matrix((data_1,(I1,J1)),shape=(NS-1,NS-1))
    A_2 = ss.coo_matrix((data_2,(I2,J2)),shape=(NS-1,NS-1))
    A = A_1+ A_2 + A_2.T
    A = A.toarray()
    
    #右端f
    f = youduan_f(x)

    uh = np.linalg.solve(A,f)
    return uh,x

#题目数据
L = -1.0       #左端点
R = 1.0     #右端点
X = []
U = []
NS1 = [5,10,20,40,80]
emaxd = np.zeros(5)
e0d = np.zeros(5)
e1d = np.zeros(5)

#误差网函数的范数
for i in range(5):
    NS = NS1[i]
    
    x,h = initial(L,R,NS)
    u = zhenjie_u(x)
    uh,x = solve(NS)   
    
    ee = u-uh
    e0 = np.sqrt(sum(ee**2)*h)
    e = (ee[1:]-ee[:-1])/h
    e1 = sum((e**2)*h)
    e1 = e1+e0 
    emax = max(abs(ee))
    e0d[i],e1d[i],emaxd[i] = e0,e1,emax          #依次给误差范数赋值
    
    #绘图准备
    X.append(x)
    U.append(uh)
#用dataframe函数显示结果
d = {'divide':[5,10,20,40,80],'e0': e0d,'e1' :e1d,'emax' :emaxd}
d = pd.DataFrame(d)
print (d)

#绘制图像
plt.figure(figsize=(20,8),dpi=80)

plt.plot(X[0],U[0],color="#FF0000",linestyle="-.",label="NS=5")
plt.plot(X[1],U[1],color="#90EE90",linestyle="-.",label="NS=10")
plt.plot(X[2],U[2],color="#0000FF",linestyle=":",label="NS=20")
plt.plot(X[3],U[3],color="#FF69B4",linestyle="--",label="NS=40")
plt.plot(X[4],U[4],color="#FF1493",linestyle="-",label="NS=80")

plt.legend()
plt.grid(linestyle = '--',alpha = 1.0)

plt.title("solution")
plt.xlabel('x')
plt.ylabel('u')

plt.show()








