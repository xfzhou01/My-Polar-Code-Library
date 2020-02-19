function indices = polar_code_construction(N,designSNRdB)
% Construct using Bhattacharyya parameter based construction,
% at "design-SNR" := (Ec/N0) = (SNR_OF_AWGN/2), given in dB
%
% See our paper for details: 
%         Vangala, H.; Viterbo, E. & Hong, Y.
%   "A Comparative Study of Polar Code Constructions for the AWGN Channel",
%          arXiv:1501.02473 [cs.IT], 2015.


z = zeros(N,1);

designSNR = 10^(designSNRdB/10);

z(1) = -designSNR; % In logdomain: actual initial Bh.Param = exp(-Ec/N0)

for lev=1:log2(N)
    B=2^lev;
    for j=1:B/2
        T = z(j);
        z(j) = logdomain_diff( log(2)+T, 2*T );  %  2z - z^2
        z(B/2 + j) = 2*T;                        %  z^2
    end
end

[~,indices] = sort(z,1,'ascend');  %default sort is "Ascending"; 
                            % 1 refers to sort "columns" (not rows)

                            
% for the least         
%lookup = zeros(N,1);
%for j=1:K 
%    lookup(indices(j)) = -1; %locations in z containing least K values
%end

end
function z=logdomain_diff(x,y)
%     x > y
% x MUST be greater than y
%
z = x + log(1 - exp(y-x));
end