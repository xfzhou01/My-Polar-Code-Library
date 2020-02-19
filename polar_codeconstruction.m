%bec信道信息位的选取
function [index,I]=polar_codeconstruction(N,e) %输入码长N和信息位长K,擦除概率e
I=zeros(1,N);                      %对信道容量赋初值
for i=1:N
    I(i)=myRecursiveFun(i,N,e);      %计算每一个信道容量I(i)
end
[~,index]=sort(I,'descend');       %对信道容量I(i)从大到小排序

end