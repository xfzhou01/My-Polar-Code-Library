function [u] = SCANdecode(y,A)
    % �涨����������
    itrMaxNum = 2;
    N = length(A);
    n = log2(N);
    L = zeros(n+1,N);
    R = zeros(n+1,N);
    u = zeros(1,N);
    
    % ��ʼ��
    L(1,:) = y;
    R(n+1,:) = (1 - A') * 10000;
    
    for i = 1 : itrMaxNum
        [L,R] = SCANiterate(L,R);
        % fprintf('end iterate %.1f',i);
    end
    
    % ֱ����ĩ�˽����о�
    for i = 1 : N
        if ((L(n+1,i)+R(n+1,i))>0 || A(1,i)==0)
            u(i) = 0;
        else
            u(i) = 1;
        end
    end
    
end

% ֻ��һ��wrapper
function [L,R] = SCANiterate(L,R)
    [L,R] = SCANRes(L,R,1,1,size(L,2), 0);
    
end


function [L,R] = SCANRes(L,R,layer,startIndex,endIndex, direction)

    % ����group number
    N = size(L,2);
    n = log2(N);
    groupLength = N / (2^(layer-1));
    groupNum = (startIndex-1) / groupLength;
    
    fprintf('layer: %.1f,  groupNum: %.1f,  direction: %.1f \n',...
             layer-1, groupNum, direction);
    % �ж��Ƿ񴫲�����
    % ǰ�򴫲����������к��򴫲�
    if layer == n + 1 && direction == 0
        [L,R] = SCANRes(L,R,layer,startIndex,endIndex,1);
        return
    end
    
    % ���򴫲�������һ�ε�������
    if layer == 1 && direction == 1
        return
    end
    
    % L���㣬ǰ�򴫲�
    if direction == 0
        L(layer+1,startIndex:floor((startIndex+endIndex)/2)) = ...
            updateL1(L(layer,startIndex:floor((startIndex+endIndex)/2)),...
                     L(layer,floor((startIndex+endIndex)/2)+1:endIndex),...
                     R(layer+1,floor((startIndex+endIndex)/2)+1:endIndex));
        [L,R] = SCANRes(L,R,layer+1,startIndex,floor((startIndex+endIndex)/2),0);
        
        L(layer+1,floor((startIndex+endIndex)/2)+1:endIndex) = ...
            updateL2(L(layer,startIndex:floor((startIndex+endIndex)/2)),...
                 L(layer,floor((startIndex+endIndex)/2)+1:endIndex),...
                 R(layer+1,startIndex:floor((startIndex+endIndex)/2)));
        [L,R] = SCANRes(L,R,layer+1,floor((startIndex+endIndex)/2)+1,endIndex,0);
    end
    % R���㣬���򴫲�
    % ֻ��odd�������ſ��Է��򴫲�
    if direction == 1 && mod(groupNum,2) == 1
        R(layer-1,startIndex-groupLength:endIndex) = ...
            updateR(L(layer-1,startIndex-groupLength:startIndex-1),...
                    L(layer-1,startIndex:endIndex),...
                    R(layer,startIndex-groupLength:startIndex-1),...
                    R(layer,startIndex:endIndex));
        [L,R] = SCANRes(L,R,layer-1,startIndex-groupLength,endIndex,1);
    end
    
end

% �����ú���
function [Lnextleft] = updateL1(Lleft,Lright,Rright)
    sumLR = Lright + Rright;
    Lnextleft = Ffun(Lleft,sumLR);
end

function [Lnextright] = updateL2(Lleft,Lright,Rleft)
    FLR = Ffun(Lleft,Rleft);
    Lnextright = Lright + FLR;
end

function [Rback] = updateR(Lleft, Lright, Rleft, Rright)
    RbackLeft = Ffun(Rleft,(Rright+Lright));
    RbackRight = Rright + Ffun(Lleft,Rleft);
    Rback = [RbackLeft RbackRight];
end


function [res] = Ffun(var1, var2)
    res = sign(var1) .* sign(var2) .* min(abs(var1),abs(var2));
end

