function [uhat] = BP(y,A,maxitr)
N = length(y);
n = log2(N);
L = zeros(n+1,N);
R = zeros(n+1,N);

L(1,:) = y;
for i = 1:N
    if A(1,i)==0
        R(n+1,i) = 1000;
    end
end


for m = 1:maxitr
    % L pro
    for i = 1 : n
        groupNum = 2^(i-1);
        groupLength = 2^(n-i+1);
        for j=0:groupNum-1
            % cal up
            L(i+1,j*groupLength+1:j*groupLength+groupLength/2) = ...
                update1(L(i,j*groupLength+1:j*groupLength+groupLength/2),...
                        L(i,j*groupLength+groupLength/2+1:j*groupLength+groupLength),...
                        R(i+1,j*groupLength+groupLength/2+1:j*groupLength+groupLength));
            % cal down
            L(i+1,j*groupLength+groupLength/2+1:j*groupLength+groupLength) = ...
                update2(L(i,j*groupLength+1:j*groupLength+groupLength/2),...
                        L(i,j*groupLength+groupLength/2+1:j*groupLength+groupLength),...
                        R(i+1,j*groupLength+1:j*groupLength+groupLength/2));
        end
    end
    % R
    for i = n+1:-1:2
        groupNum = 2^(i-1);
        groupLength = 2^(n-i+1);
        for j=0:groupNum/2-1
            % cal up
            R(i-1,j*groupLength*2+1:j*groupLength*2+groupLength) = ...
                update1(R(i,j*groupLength*2+1:j*groupLength*2+groupLength),...
                        R(i,j*groupLength*2+groupLength+1:j*groupLength*2+groupLength*2),...
                        L(i-1,j*groupLength*2+groupLength+1:j*groupLength*2+groupLength*2));
            % cal down
            R(i-1,j*groupLength*2+groupLength+1:j*groupLength*2+groupLength*2) = ...
                update2(R(i,j*groupLength*2+1:j*groupLength*2+groupLength),...
                        R(i,j*groupLength*2+groupLength+1:j*groupLength*2+groupLength*2),...
                        L(i-1,j*groupLength*2+1:j*groupLength*2+groupLength));
        end
    end
end

% decision
u = ones(1,N);
for i = 1:N
    if (R(n+1,i)+L(n+1,i))>0 || A(i) == 0
        u(i) = 0;
    end
end

uhat = u;

end

function [result] = update1(left1,left2,right2)
    sumLR = left2 + right2;
    result = Ffun(left1, sumLR);
end

function [result] = update2(left1,left2,right1)
    FLR = Ffun(left1,right1);
    result = left2 + FLR;
end

function [res] = Ffun(var1, var2)
    res = sign(var1) .* sign(var2) .* min(abs(var1),abs(var2));
end

