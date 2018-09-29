function out = meshPolyVal(P, x, y, n)
%     out = P(1).* x.^3.*y.^0 + P(2).* x.^2.*y.^1 + P(3).* x.^1.*y.^2 + P(4).* x.^0.*y.^3 ...
%             + P(5).* x.^2.*y.^0 + P(6).* x.^1.*y.^1 + P(7).* x.^0.*y.^2 ...
%                 + P(8).* x + P(9).* y + P(10);
%
if nargin<4
    n = 4; % third order
else
    n = n + 1;
end
k = 1;
% out = zeros(size(x));
for i = n:-1:1
    for j=1:i
        z(:,k) =  P(k).*((x.^(i-j)).*(y.^(j-1))) ;
        k = k + 1;
    end
end
out = z*P';