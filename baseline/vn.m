% [X,lx,Z] = vn(Y,W,d,L)
% Variational Nyström algorithm for fast Laplacian Eigenmaps
%
% This computes a fast, approximate Laplacian Eigenmaps embedding for a
% high-dimensional dataset using the Variational Nyström (VN) algorithm.
%
% For details about how to select the landmarks (indices lx) see function 
% lmarks.m.
%
% It should be easy to modify vn.m to solve spectral problems other than
% Laplacian Eigenmaps, say LLE, by constructing the relevant graph Laplacian
% and the matrices A and B below.
%
% In:
%   Y: NxD matrix of N row D-dimensional vectors.
%   W: NxN affinity matrix (usually sparse).
%   d: dimension of the latent space.
%   L: number of landmarks.
% Out:
%   X: N x d matrix of N row d-dimensional vectors, the projections of Y.
%   lx: 1xL list of the indices of the landmarks in Y: Y0=Y(lx,:), X0=X(lx,:).
%   Z: LxN matrix of reconstruction weights.
%
% Any non-mandatory argument can be given the value [] to force it to take
% its default value.

% Copyright (c) 2016 by Max Vladymyrov and Miguel A. Carreira-Perpinan

function [X,lx,Z, time_sampling, time_construct,time_eig] = vn(Y,W,d,L, s)
tic;
% Find L landmarks at random (can also use kmeans)
[~,lx] = lmarks(Y,L,'kmeans',s);
time_sampling = toc;
tic;
% Construct full graph Laplacian
D = sum(W,2); DD = diag(sparse(D.^(-1/2))); LL = DD*W*DD;

C = W(lx,:); DC = sum(C,2); DDC = diag(sparse(DC.^(-1))); Z = DDC*C;

% Affinity matrix A for the reduced spectral problem (landmarks-only)
A = Z*LL*Z'; A = (A+A')/2; B = Z*Z'; B = (B+B')/2;

% Solve the reduced spectral problem. We can do this either by solving a
% generalized or a standard eigenvalue problem. They have a similar runtime.
% The solution through the generalized eigenvalue problem:
time_construct =toc;
tic;

opts.issym = 1; opts.isreal = 1; opts.disp = 0;
[U,E] = eigs(A,B,d+1,'lm',opts); E = diag(E); [~,ind] = sort(E,1,'descend');
X0 = U(:,ind(2:d+1));
time_eig = toc;
% $$$ % The solution through the standard eigenvalue problem:
% $$$ BB = sqrtm(full(B)); C = (BB\A)/BB; C = (C+C')/2;
% $$$ [U,E] = eig(C); E = diag(E); [~,ind] = sort(E,1,'descend'); U = U(:,ind(2:d+1));
% $$$ X0 = BB\U;

% Construct the projections for the rest of the points (out-of-sample mapping)
X = DD*Z'*X0;
time_eig = toc;
