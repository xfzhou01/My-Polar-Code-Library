%���ɾ���GN��F^n�Ķ���
function A=Fn(N)
F=[1,0;1,1];
n=log2(N);
A=[1,0;1,1];
for i=1:n-1
    A=kron(A,F); %�����ڿ˻�
end