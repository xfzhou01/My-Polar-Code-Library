%bec�ŵ���Ϣλ��ѡȡ
function [index,I]=polar_codeconstruction(N,e) %�����볤N����Ϣλ��K,��������e
I=zeros(1,N);                      %���ŵ���������ֵ
for i=1:N
    I(i)=myRecursiveFun(i,N,e);      %����ÿһ���ŵ�����I(i)
end
[~,index]=sort(I,'descend');       %���ŵ�����I(i)�Ӵ�С����

end