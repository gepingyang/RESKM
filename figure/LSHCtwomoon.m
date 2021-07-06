clear;
%drawing figure3 (c)
load('./dataset/TwoMoons.mat');
n = size(fea, 1);
 K = 2;
config.cols = {'r','b','y','g','m','k','c','r','b','y'};
rand('seed',1);    
fprintf('Seed No: %d\n',i);
r = 3;
a = 50;
[dump, marks] = litekmeans(fea,a,'MaxIter', 3,'Replicates',1);
clear indSmp kmMaxIter kmNumRep
D = EuDist2(fea,marks,0);
sigma = mean(mean(D));
dump = zeros(n,r);
idx = dump;
for i = 1:r
    [dump(:,i),idx(:,i)] = min(D,[],2);
    temp = (idx(:,i)-1)*n+[1:n]';
    D(temp) = 1e100; 
end
dump = exp(-dump/(2*sigma ));
Gsdx = dump;
Gidx = repmat([1:n]',1,r);
Gjdx = idx;
Z=sparse(Gidx(:),Gjdx(:),Gsdx(:),n,a);
[Z] =calAffinityMatrix(Z);
%step 3: Compute the eignvector of W
[C, U] = cal_eigen(Z, K);
clear Z;
%step 4: Perform anchor kmeans
[label, center, ~] = litekmeans(C,K,'MaxIter',100,'Replicates',1);
clear D bb ab labels  dump
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  visualize 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
for eee = 1:n
     plot(fea(eee,1),fea(eee,2),[config.cols{label(eee)},'x'],'markerfacecolor',config.cols{label(eee)},'MarkerSize',10);
    hold on
end


disp('Algorithm Finished');



