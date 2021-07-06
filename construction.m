function [Z] = construction(data, anchors, opts )
%   graph constrcution

% Set and parse parameters
if (~exist('opts','var'))
   opts = [];
end
% the number of anchors
a = 1000;
if isfield(opts, 'a')
    a = opts.a;
end
% tthe number of neighbour anchors
r = 2;
if isfield(opts,'r')
    r = opts.r;
end
nSmp=size(data,1);

% Z construction
   
D = EuDist2(data,anchors,0);
if isfield(opts,'sigma')
    sigma = opts.sigma;
else
    sigma = mean(mean(D));
end



% find the r nearest anchors
dump = zeros(nSmp,r);
idx = dump;

for i = 1:r
    [dump(:,i),idx(:,i)] = min(D,[],2);
    temp = (idx(:,i)-1)*nSmp+[1:nSmp]';
    D(temp) = 1e100; 
end

dump = exp(-dump/(2*sigma ));
Gsdx = dump;
Gidx = repmat([1:nSmp]',1,r);
Gjdx = idx;
Z=sparse(Gidx(:),Gjdx(:),Gsdx(:),nSmp,a);
%normalize
D_a = 1./(sqrt(sum(Z,2))+10^(-6));
D_o = 1./(sqrt(sum(Z,1))+10^(-6));
Z = repmat(D_a,1,a).* Z .* repmat(D_o,nSmp, 1);

end

