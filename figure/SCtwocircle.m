clear;
load('./dataset/twocircle.mat');
n = size(fea, 1);
k = 2;
r = 9;
%drawing figure3 (b)                                   
config.cols = {'r','b','y','g','m','k','c','r','b','y'};
rand('seed',1);    
W = gaussaff(fea,{'k',r});
D = sum(W, 2);
D = sqrt(1./D);
D = spdiags(D, 0, n, n);
L =   D * W * D;
clear D S W;

OPTS.disp = 0;
[V, val] = eigs(L, k + 1, 'LM', OPTS);
clear val
V(:, 1) = [];
sq_sum = sqrt(sum(V.*V, 2)) + 1e-20;
V = V ./ repmat(sq_sum, 1, k);
[label] = litekmeans(V, k, 'MaxIter', 50, 'Replicates', 1);

for eee = 1:n
     plot(fea(eee,1),fea(eee,2),[config.cols{label(eee)},'x'],'markerfacecolor',config.cols{label(eee)},'MarkerSize',10);
    hold on
end
hold off;                
disp('Algorithm Finished');



