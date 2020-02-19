%生成矩阵GN中F^n的定义
function A=Fn(N)
F=[1,0;1,1];
n=log2(N);
A=[1,0;1,1];
for i=1:n-1
    A=kron(A,F); %克罗内克积
end