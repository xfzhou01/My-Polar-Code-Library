%polar encode的定义
function x=polar_encode(u)
N=size(u,2);     %计算码字长度bitrevorder
x=mod(u*Fn(N),2); %编码过程，bitrevorder代表比特翻转操作，Fn(N)为矩阵F^n
end