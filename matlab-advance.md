## Matlab 进阶

在数值实验上机课程中，学生使用 Matlab 还存在很多问题，这里总结一下，并给出详细的
示例与解释。

## 数组运算和矩阵向量运算

```matlab
function val = compute(x)
    val = sin(4*pi*x.*x) + cos(pi*x.^2)*sin(pi*x.^3);
end
```

```matlab
x = [0.1, 0.2, 0.3, 0.4];
val = compute(x); 
```

## 程序的调试

1. 如何阅读理解出错信息
1. 如何调试
    + 设置断点
    + 显示变量的当前值
