
min_EbN0=0.5;
max_EbN0=3.5;
EbN0_step=0.5;
EbN0_set=min_EbN0:EbN0_step:max_EbN0;

BER=zeros(1,length(EbN0_set));
FER=zeros(1,length(EbN0_set));

N = 1024;
K = 512;


% rank_index = polar_codeconstruction(N,0.5);
% rank_index=rank_index'; 

% 5G
rank_index = getSeq();
rank_index = rank_index + 1;
info_index = rank_index(1,N-K+1:N);
A = zeros(1,N);
A(info_index) = 1;

global bitNum;
bitNum = 0;
for i = 1 : length(EbN0_set)
    currentEbN0 = EbN0_set(i);
    N0 = 1/(((K)/N)*(10^(currentEbN0/10)));
    sigma_sq = N0/2;
    
    % 测试信息
    itrNum = 0;
    feNum = 0;
    beNumT = 0;
    while feNum < 100
        % 迭代1w次以上，且最少错100帧
        % Generate, Encode
        u = zeros(1,N);
        itrNum = itrNum + 1;
        data = randi(2,1,K) - 1;
        u(1,info_index)= data;
        x = polar_encode(u);
        % Channel
        BPSK = 1 - 2 * x;
        noise = sqrt(sigma_sq)*randn(size(BPSK));
        y = BPSK + noise;
        
        % Decode
        % uhat = SCdecode(y,A);
        % uhat = SCANdecode(y,A);
        uhat = BP(y,A,20);
        % Check
        be = sum(uhat~=u);
        if be > 0
            feNum = feNum + 1;
            beNumT = beNumT + be;
        end
        
        % fprintf('Error Flame = %.0f\n', feNum);
        % reset
        bitNum = 0;
    end
    
    BER(i) = beNumT / (itrNum * N);
    FER(i) = feNum / itrNum;
    
    fprintf('Eb/NO = %.7f, BER = %.7f, FER = %.7f ITR = %.1f\n', currentEbN0, BER(i), FER(i),itrNum);
    
end


% 单纯的SC
save('SC_BER_N1024_K512_S.mat','BER');
save('SC_FER_N1024_K512_S.mat','FER');

% SCAN，两次迭代
% save('SCAN_2ITR_BER_N1024_K512_0_3_02.mat','BER');
% save('SCAN_2ITR_FER_N1024_K512_0_3_02.mat','FER');

% SCAN，四次迭代
% save('SCAN_4ITR_BER_N1024_K512_0_3_02.mat','BER');
% save('SCAN_4ITR_FER_N1024_K512_0_3_02.mat','FER');

% SCAN，八次迭代
% save('SCAN_8ITR_BER_N1024_K512_0_3_02.mat','BER');
% save('SCAN_8ITR_FER_N1024_K512_0_3_02.mat','FER');

% SCAN，16次迭代
% save('SCAN_16ITR_BER_N1024_K512_0_3_02.mat','BER');
% save('SCAN_16ITR_FER_N1024_K512_0_3_02.mat','FER');
