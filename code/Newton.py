import matplotlib.pyplot as plt
import numpy as np

n=10
def RUNGR(x):
    y=1/(1+x**2)
    return y
xdate=np.linspace(-5,5,n+1)#选取节点
ydate=RUNGR(xdate)
print(ydate)#节点函数值
#定义Newton插值多项式函数
def NT(x):
    shuju=[0,1,2,3,4,5,6,7,8,9,10]#差商的次数
    shuju2=[0,1,2,3,4,5,6,7,8,9,10]#每阶差商的个数
    nt=[0.03846154,0.05882353,0.1,0.2,0.5,1,0.5,0.2,0.1,0.05882353,0.03846154]#迭代过程中用来存放每阶差商的数组
    nto=[]#存放多项式在已选定基下的坐标
    y=0
    #j的迭代是计算多项式的坐标
    for j in shuju:
        if j>0:
           shuju2.remove(11-j)
           #i的迭代是计算所有的j阶差商
           for i in shuju2:
               nt[i]=(nt[i+1]-nt[i])/(xdate[i+j]-xdate[i])#计算差商
        nto.append(nt[0])#迭代结束后nto保存了坐标
    #下面就是让基跟坐标相乘    
    for l in shuju:
        if l>0:
           shuju4=shuju[0:l]
           for k in shuju4:
               nto[l]*=(x-xdate[k])
        y+=nto[l]
    return y
#画图
x1=np.arange(-5.0, 5.0, 0.01)
y1=NT(x1)
y2=RUNGR(x1)
plt.plot(x1, y1)
plt.plot(x1, y2,'r')    