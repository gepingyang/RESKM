function [anchors] = anchorselection(fea, opts)
%This function is to select anchors
nSmp=size(fea,1);
if (~exist('opts','var'))
   opts = [];
end
s = 3400;
if isfield(opts, 's')
    s = opts.s;
end
% # of the anchor
a = 1000;
if isfield(opts, 'a')
    a = opts.a;
end
kmMaxIter = 3;
if isfield(opts,'kmMaxIter')
    kmMaxIter = opts.kmMaxIter;
end
kmNumRep = 1;
if isfield(opts,'kmNumRep')
    kmNumRep = opts.kmNumRep;
end
indSmp = randperm(nSmp);
[dump, anchors] = litekmeans(fea(indSmp(1:s),:),a,'MaxIter', kmMaxIter,'Replicates',kmNumRep);
clear indSmp dump
end