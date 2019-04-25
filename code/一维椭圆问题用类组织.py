# -*- coding: utf-8 -*-
"""
Created on Wed Apr 24 18:25:51 2019

@author: UESRDER
"""

import numpy as np
import matplotlib.pyplot as plt
import scipy.sparse as ss
import pandas as pd


#将数据封装的类

class Datapackage(object):
    def __init__(self, L, R):
        self.L = L
        self.R = R

    def figure(self):
        Figure.initial(self.L,self.R,self.N)
        x,h=Figure.initial(self.L,self.R,self.N)
        
        Figure.zhenjie_u(x)
        u = Figure.zhenjie_u(x)
        
        Figure.youduan_f(x)
        f = Figure.youduan_f(x)
        
        Figure.solve(x,h,self.N,f)
        uh = Figure.solve(x,h,self.N,f)
        
        return uh,u,h
    
    def wucha(self,uh,u,h):
        ee = u-uh
        
        e0 = np.sqrt(sum(ee**2)*h)
        e = (ee[1:]-ee[:-1])/h
        e1 = sum((e**2)*h)
        e1 = e1+e0 
        emax = max(abs(ee))     
        return e0,e1,emax
        


#将方法封装的类
        
class Figure(object):              
    def initial(L,R,NS):
        x = np.linspace(L,R,NS+1)
        h = (R-L) / NS
        x = x[1:-1]
        return x,h
   
    def zhenjie_u(x):
        u = (1-x**2)*np.exp(-x**2)
        return u
    
    def youduan_f(x):
        f = (4*x**4-15*x**2+5)*np.exp(-x**2)
        return f
    
    
    #解方程
    def solve(x,h,NS,f):

        
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
    
        uh = np.linalg.solve(A,f)
        return uh
    
emaxd = np.zeros(5)
e0d = np.zeros(5)
e1d = np.zeros(5)

NS = [5,10,20,40,80]
datapackage = Datapackage(-1,1)

#制作误差表格
for i in range(5):
    datapackage.N =NS[i]
    a,b,h = datapackage.figure()
    e0,e1,emax = datapackage.wucha(a,b,h)
    e0d[i],e1d[i],emaxd[i] = e0,e1,emax
#用dataframe函数显示结果
d = {'divide':[5,10,20,40,80],'e0': e0d,'e1' :e1d,'emax' :emaxd}
d = pd.DataFrame(d)
print (d)
    
    

