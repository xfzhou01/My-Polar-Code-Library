%polar encode�Ķ���
function x=polar_encode(u)
N=size(u,2);     %�������ֳ���bitrevorder
x=mod(u*Fn(N),2); %������̣�bitrevorder������ط�ת������Fn(N)Ϊ����F^n
end