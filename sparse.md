# 稀疏矩阵

给定一个矩阵 A， 如果其非零元个数比较少， 我们就称其为**稀疏矩阵**。 稀疏矩阵是
数值计算中经常用到的矩阵类型， 如有限元、有限差分、有限体积等常用的偏微分方程数
值求解方法，最后得到的都是稀疏矩阵。 因此， 学习数值计算很有必要了解这种矩阵在计
算机中的存储格式。

在计算机中存储稀疏矩阵时， 如果把每个元素都存下来， 是很浪费存储空间的。 比如一
个 10 万阶的方阵, 包含 10 亿个元素， 但假设其中只有 20 万个非零元。 在计算机中按
双精度存储的话, 每个矩阵元素要占 8 个字节。 如果把所有元素都存储下来, 大概需要
74.5 GB 的内存空间， 其计算公式如下：

$$ 
\frac{\text{10 万阶矩阵的字节数}}{\text{1 GB 的字节数}} = \frac{10^5\times 10^5\times 8}{2^{10}\times 2^{10}\times 2^{10}} \approx 74.5 (GB),
$$

对一般的中小规模计算机， 在内存中直接存储 10 万阶的矩阵是不可能的事情。 唯一的办
法就是利用稀疏矩阵大部分元素为 0 的这个特点。 因此， 我们需要为稀疏矩阵设计不同
的存储格式。 常用的稀疏矩阵存储格式有：

* Coordinate format Matrix \(COO\): 坐标格式稀疏矩阵， 用相同长度的三个一维数组 
  `data`, `I` 和 `J` 分别存**非零元**及其对应的**行列指标**， 三个数组长度都为矩阵中非零元的个数。
* Compressed Sparse Row Matrix \(CSR\): 压缩稀疏行存储矩阵， 用两个相同长度的一维数组 `data` 和 `indices` 分别存储**非零元**和其对应的**列指标**， 这两个数组的长度为非零元的个数; 用另外一个数组 `indptr` 存储**每一行**的非零元和其列指标在 `data` 和 `indices` 中的**起始**和**终止**位置， 长度要比**矩阵行数**多 1。
* Compressed Sparse Column Matrix \(CSC\)：压缩稀疏列存储矩阵，用两个相同长度的一维数组 `data` 和 `indices` 分别存储**非零元**和其对应的**行指标**， 这两个数组的长度为非零元的个数; 用另外一个数组 `indptr` 存储**每一列**的非零元和其列指标在 `data` 和 `indices` 中的**起始**和**终止位置**， 长度要比**矩阵列数**多 1。

## 稀疏矩阵示例

下面以一个具体的矩阵为例， 对上面三种格式进行说明:

$$
A = \begin{pmatrix} 
 0 & 0 & 0 & 10 \\
 21 & 0 & 33 & 0 \\ 
 0 & 0 & 3 & 0 \\ 
 12 & 1 & 0 & 4 
 \end{pmatrix}
$$

**注意**下面我们采用 C\C++ 和 Python 的习惯， 矩阵行列编号都从 **0** 开始. 首先是 COO 格式， 可以**行优先存储**:

$$
\begin{aligned} 
data &= [10, 21,33,3,12,1,4], \\
I &= [0, 1, 1, 2, 3, 3, 3], \\
J &= [3, 0, 2, 2, 0, 1, 3]. 
\end{aligned}
$$

也可以**列优先存储**:

$$
\begin{aligned}
data &=[21, 12, 1, 33, 3, 10, 4], \\
I &=[1, 3, 3, 1, 2, 0, 3], \\
J &=[0, 0, 1, 2, 2,, 3, 3]. 
\end{aligned}
$$

可以看到上面的两种格式， 同一行或同一列的指标存储有点冗余， 这里仍有改进空间。

比如， CSR 用下面三个数组来表示矩阵 A：

$$
\begin{aligned} 
data &= [10,21,33,3,12,1,4], \\
indices &= [3,0,2,2,0,1,3], \\ 
indptr &= [0,1,3,4,7].
\end{aligned}
$$

其中， `data[indptr[i]:indptr[i+1]]` 是第 i 行所有非零元，
`indices[indptr[i]:indptr[i+1]]` 是第 i 行所有非零元的列指标。 注意， 这里用了
Python 中的**切片**语法 `start:stop:step`。 

CSC 可以用下面三个数组来表示矩阵 A:

$$
\begin{aligned} 
data &= [21,12,1,33,3,10,4], \\
indices &= [1,3,3,1,2,0,3], \\
indptr &= [0,2,3,5,7]. 
\end{aligned}
$$

其中， `data[indptr[i]:indptr[i+1]]` 是**第 i 列**所有非零元，
`indices[indptr[i]:indptr[i+1]]` 是**第 i 列**所有非零元的**行指标**。 

还以上面的 10 万阶方矩阵为例, 假设有 20 万个非零元, 用双精度存储， 指标数组用 32
位整型存储， 在 CSR 模式下, 它占用内存为\(以 MB 为单位\):

$$
\frac{2 \times 10^5 \times 8 + 10^5 \times 4 + (10^5+1) \times 4}{2^{10}\times 2^{10}} \approx 2.29 (MB).
$$

哈哈, 内存节省了大概 33333 倍。


## Matlab 中稀疏矩阵

Matlab 中创建稀疏矩阵的命令为 `sparse`, 请在以下网址中学习该命令的用法。

https://ww2.mathworks.cn/help/matlab/ref/sparse.html

并完成如下实验：
1. 利用 `S = sparse(i, j, v, m, n)` 命令创建一个 $$ 10000 \times 10000 $$  三对角稀疏矩阵，主对角元素值都为 2, 上下两个次
   对角元素值都为 -1。
1. 把上面的稀疏矩阵转化为满矩阵，并比较两种形式下矩阵占用的内存。


<div id="container"></div>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/theme-next/theme-next-gitment@1/default.css"/>
<script src="https://cdn.jsdelivr.net/gh/theme-next/theme-next-gitment@1/gitment.browser.js"></script>

<script>
var gitment = new Gitment({
  id: md5(window.location.pathname), // 可选。默认为 location.href
  owner: 'weihuayi',
  repo: 'weihuayi.github.io',
  oauth: {
    client_id: '7dd9c9fc3ac45352b55b',
    client_secret: '4e6f74b82a7ac18671c7e9e0d17a1ceb9359a5ad',
  },
})

gitment.render('container')
</script>
