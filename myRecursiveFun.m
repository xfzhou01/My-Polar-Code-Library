
function y = myRecursiveFun(m,N,e) %�ݹ麯��
 

if m ==1 && N == 1  %��ʼֵ
 
    y = 1-e;
 
else
 
    if rem(m,2)  %iΪ����
 
        y = myRecursiveFun((m+1)/2,N/2,e).^2;
 
    else     %iΪż��
 
        temp = myRecursiveFun(m/2,N/2,e);
 
        y = 2*temp-temp.^2;
 
    end
 
end
