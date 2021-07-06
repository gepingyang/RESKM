function [anchors] = anchorselection(fea, opts)
%This function is to select anchors
nSmp=size(fea,1);
if (~exist('opts','var'))
   opts = [];
end
% the number of data objects to perform a-means 
s = 3400;
if isfield(opts, 's')
    s = opts.s;
end
% the number of the anchors
a = 1000;
if isfield(opts, 'a')
    a = opts.a;
end
% the number of iterations of anchor a-means.
kmMaxIter = 3;
if isfield(opts,'kmMaxIter')
    kmMaxIter = opts.kmMaxIter;
end
% the number of times to repeat a-means, alaways one.
kmNumRep = 1;
if isfield(opts,'kmNumRep')
    kmNumRep = opts.kmNumRep;
end
indSmp = randperm(nSmp);
[dump, anchors] = litekmeans(fea(indSmp(1:s),:),a,'MaxIter', kmMaxIter,'Replicates',kmNumRep);
clear indSmp dump
end
