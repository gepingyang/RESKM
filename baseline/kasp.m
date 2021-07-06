function[label, sampling_time, eigen_time, contruct_time, k_means] =  kasp(data,a, k, sigma, numRep, s, kmMaxIter)
if ~exist('a', 'var')
    a=600; 
end
if ~exist('sigma',  'var') 
    sigma = 20; 
end

if ~exist('numRep',  'var') 
    numRep=1; 
end
if ~exist('s',  'var') 
    s=0; 
end    
if ~exist('kmNumRep',  'var') 
    kmNumRep=1; 
end  
if ~exist('kmMaxIter',  'var') 
    kmMaxIter=3; 
end  
[N,m]  = size(data);
tic;
if s == 0
    s = N;
end
if s == N
    [dump, anchors] = litekmeans(data,a,'MaxIter', kmMaxIter,'Replicates',kmNumRep);
else
    
    indSmp = randperm(N);
    [dump, anchors] = litekmeans(data(indSmp(1:s),:),a,'MaxIter', kmMaxIter,'Replicates',kmNumRep);
end
sampling_time = toc;
tic;
W = EuDist2(anchors,anchors, 0);

if s == N
  Max_ind = dump;  
else
   DD = EuDist2(data, anchors, 2);
   [dump, Max_ind] = min(DD, [], 2);
end
clear dump anchors

W = exp(-W / 2 / sigma/  sigma);
D = sum(W, 2);
D = sqrt(1./D);
D = spdiags(D, 0, a, a);
L =   D * W * D;
contruct_time = toc;
clear D S W;
tic;
OPTS.disp = 0;
[V, val] = eigs(L, k, 'LM', OPTS);
clear val
sq_sum = sqrt(sum(V.*V, 2)) + 1e-20;
V = V ./ repmat(sq_sum, 1, k);
eigen_time = toc;
tic;
[label] = litekmeans(V,k,'MaxIter', 50,'Replicates',1);

label = label(Max_ind);
clear V Max_ind
k_means = toc;


