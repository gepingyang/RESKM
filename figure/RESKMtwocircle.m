clear;

load('./dataset/twocircle.mat');
[n, p] = size(fea);
%drawing figure3 (d)
[n] = size(fea, 1);
K = 2;
r = 2;
s = 200;
a = 50;
config.cols = {'b','r','y','g','m','k','c','r','b','y'};

rand('seed',1);    
fprintf('Seed No: %d\n',i);
%step 1: Select Anchors 
kmMaxIter = 3;
kmNumRep = 1;
indSmp = randperm(n);
ind_selected = indSmp(1:s);
ind_unselected = indSmp(s + 1: n);
[dump, anchors] = litekmeans(fea(ind_selected,:),a,'MaxIter', kmMaxIter,'Replicates',kmNumRep);
clear indSmp kmMaxIter kmNumRep
%step 2: Construct Graph   
D = EuDist2(fea,anchors,0);
sigma = mean(mean(D));
dump = zeros(n,r);
idx = dump;
for i = 1:r
    [dump(:,i),idx(:,i)] = min(D,[],2);
    temp = (idx(:,i)-1)*n+[1:n]';
    D(temp) = 1e100; 
end
dump = exp(-dump/(2*sigma));
Gsdx = dump;
Gidx = repmat([1:n]',1,r);
Gjdx = idx;
Z=sparse(Gidx(:),Gjdx(:),Gsdx(:),n,a);
D_a = 1./(sqrt(sum(Z,2))+10^(-6));
D_o = 1./(sqrt(sum(Z,1))+10^(-6));
Z = repmat(D_a,1,a).* Z .* repmat(D_o,n, 1);
%step 3: Compute the eignvector of anchor space
[U_o, U_a] = cal_eigen(Z, K);
clear Z;
%step 4: Perform anchor kmeans
[label2, C_a, ~] = litekmeans(U_a,K,'MaxIter',50,'Replicates',1);
bb = full(sum(C_a.*C_a,2)');
ab = full(U_o*C_a');
D = bb(ones(1,n),:) - 2*ab;
[dump, label] = min(D, [], 2);
clear D bb ab labels  dump
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  visualize 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                      
                     
for eee = ind_selected
     plot(fea(eee,1),fea(eee,2),[config.cols{label(eee)},'x'],'markerfacecolor',config.cols{label(eee)},'MarkerSize',10);
    hold on
end
for eee =ind_unselected
     plot(fea(eee,1),fea(eee,2),[config.cols{label(eee)},'s'],'markerfacecolor',config.cols{label(eee)},'MarkerSize',2);
    hold on
end
disp('Algorithm Finished');

