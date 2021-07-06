function [Z,sampling_time] = pretreatmentanchor(data, opts )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Set and parse parameters
if (~exist('opts','var'))
   opts = [];
end

s = 10000;
if isfield(opts, 's')
    s = opts.s;
end
% # of the anchor
a = 1000;
if isfield(opts, 'a')
    a = opts.a;
end
% the # nearest neighbour anchor
r = 5;
if isfield(opts,'r')
    r = opts.r;
end

%
maxIter = 100;
if isfield(opts,'maxIter')
    maxIter = opts.maxIter;
end


numRep = 1;
if isfield(opts,'numRep')
    numRep = opts.numRep;
end



% the mode of select anchor
% mode = 'kmeans';
mode = 'random';
if isfield(opts,'mode')
    mode = opts.mode;
end


nSmp=size(data,1);
tic;
% Landmark selection
if strcmp(mode,'kmeans')
    
    %k-means select anchor
     kmMaxIter = 3;
    if isfield(opts,'kmMaxIter')
        kmMaxIter = opts.kmMaxIter;
    end
    kmNumRep = 1;
    if isfield(opts,'kmNumRep')
        kmNumRep = opts.kmNumRep;
    end
    [dump,marks]=litekmeans(data,a,'MaxIter',kmMaxIter,'Replicates',kmNumRep);
    clear kmMaxIter kmNumRep
    
elseif strcmp(mode,'random')
    %ramdom select anchor
    indSmp = randperm(nSmp);
    marks = data(indSmp(1:a),:);% random select anchor
    clear indSmp
elseif strcmp(mode,'bkmeans')
    kmMaxIter = 3;
    if isfield(opts,'kmMaxIter')
        kmMaxIter = opts.kmMaxIter;
    end
    kmNumRep = 1;
    if isfield(opts,'kmNumRep')
        kmNumRep = opts.kmNumRep;
    end
    indSmp = randperm(nSmp);
    [dump, marks] = litekmeans(data(indSmp(1:s),:),a,'MaxIter', kmMaxIter,'Replicates',kmNumRep);
    clear  indSmp
else
    error('mode does not support!');
end
sampling_time = toc;

% Z construction

D = EuDist2(data,marks,0);


if isfield(opts,'sigma')
    sigma = opts.sigma;
else
    sigma = mean(mean(D));
end



% find the r nearest anchor
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


end

