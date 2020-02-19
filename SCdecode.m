function [u] = SCdecode(y,A)
    xhat = SCRes(y,A);
    u=polar_encode(xhat);
end

function [beta] = SCRes(alpha,A)
    global bitNum;
    if length(alpha)==1
        bitNum = bitNum + 1;
        if (alpha(1,1)>0)||(A(1,bitNum)==0)
            beta = 0;
        else
            beta = 1;
        end
        return;
    end
    
    alpha_left = Ffunction(alpha);
    beta_left = SCRes(alpha_left,A);
    alpha_right = GFunction(alpha, beta_left);
    beta_right = SCRes(alpha_right,A);
    beta=zeros(1,length(alpha));
    beta(1,1:length(alpha)/2) = xor(beta_left,beta_right);
    beta(1,length(alpha)/2+1:end) = beta_right;
end


function [alpha_left] = Ffunction(alpha)
    halfIndex = length(alpha)/2;
    alpha1 = alpha(1,1:halfIndex);
    alpha2 = alpha(1,halfIndex+1:end);
    % alpha_left = realFun(alpha1,alpha2);
    alpha_left = sign(alpha1) .* sign(alpha2) .* min(abs(alpha1),abs(alpha2));
end


function [alpha_right] = GFunction(alpha, beta1)
    halfIndex = length(alpha)/2;
    alpha1 = alpha(1,1:halfIndex);
    alpha2 = alpha(1,halfIndex+1:end);
    temp = 1 - 2 * beta1;
    alpha_right = alpha2 + temp .* alpha1;
end

function [res] = realFun(left,right)
    res = log((1+exp(left+right))./(exp(left)+exp(right)));
end

