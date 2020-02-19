
function y = myRecursiveFun(m,N,e) %递归函数
 

if m ==1 && N == 1  %初始值
 
    y = 1-e;
 
else
 
    if rem(m,2)  %i为奇数
 
        y = myRecursiveFun((m+1)/2,N/2,e).^2;
 
    else     %i为偶数
 
        temp = myRecursiveFun(m/2,N/2,e);
 
        y = 2*temp-temp.^2;
 
    end
 
end
