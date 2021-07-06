% [Y0,lx] = lmarks(Y,L[,method]) Select L landmarks from a dataset
%
% This selects L landmarks from the data Y in one of the following two ways:
% - at random from the data, and then removing 20% of the landmarks that are
%   closest to each other;
% - as the centroids of k-means.
%
% In:
%   Y: NxD matrix of N row D-dimensional vectors.
%   L: number of landmarks.
%   method: how to select landmarks, 'random' or 'kmeans'. Default: 'random'.
% Out:
%   Y0: LxD matrix of L row D-dimensional vectors, the landmarks.
%   lx: 1xL list of the indices of the landmarks in Y: Y0=Y(lx,:).
%
% Any non-mandatory argument can be given the value [] to force it to take
% its default value.

% Copyright (c) 2013 by Max Vladymyrov and Miguel A. Carreira-Perpinan

function [Y0,lx] = lmarks(Y,L,method, s)

% ---------- Argument defaults ----------
if ~exist('method','var') || isempty(method) method='kmeans'; end
% ---------- End of "argument defaults" ----------
nSmp = size(Y, 1);
if ~exist('s','var') || isempty(s)  s  = 0; end
switch method 
 case 'kmeans'
     disp('kmeans sampling');
  tmp = round(L*0.2);		% add 20% more points temporarily
  indSmp = randperm(nSmp);
  if s == 0
      s = nSmp;
  end
  [~, mu] = litekmeans(Y(indSmp(1:s),:),L + tmp,'MaxIter', 3,'Replicates',1);
%   [~,mu] = litekmeans(Y,L+tmp,'MaxIter',3,'Replicates',1);
  [~,lx] = min(sqdist(Y,mu));
  lx = unique(lx);
  mu = Y(lx,:);
  if length(lx)>L		% remove excess points (at random)
    ind = randperm(length(lx));
    lx = lx(ind(1:L));		% landmark index
  end
  Y0 = Y(lx,:);
 case 'random'
     disp("random")
  tmp = round(L*0.2);		% add 20% more points temporarily
  N = size(Y,1);
  lx = randperm(N);
  %lx = lx(1:(L+tmp));
  lx = lx(1: L);
  Y0 = Y(lx,:);
  % Remove points that are closest to each other
  %sqd = sqdist(Y0);
  %sqd(1:L+tmp+1:(L+tmp)^2) = Inf;
  %[~,ind] = sort(min(sqd));	% find closest landmarks
  %Y0(ind(1:2:2*tmp),:) = [];
  %lx(ind(1:2:2*tmp)) = [];
end

