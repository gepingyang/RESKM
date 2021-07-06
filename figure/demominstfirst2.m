clear;
load('./dataset/mnist10k.mat');
fea = double(fea);
%drawing figure2 (a)
fea = full(fea);
K = 5;
[n, p] = size(fea);
config.cols = {'k','m','c','g','y'};
config.cols1 = {'c','g','m' ,'k','y'};
rand('seed',1);    
r =2;
a = 600;
s = 3000;
%step 1: Select Anchors 
kmMaxIter = 3;
kmNumRep = 1;
indSmp = randperm(n);
[dump, anchors] = litekmeans(fea(indSmp(1:s),:),a,'MaxIter', kmMaxIter,'Replicates',kmNumRep);
clear indSmp kmMaxIter kmNumRep dump
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
Z = repmat(D_a,1,a).* Z .* repmat(D_o,n, 1);clear H;               
[U_o, U_a] = cal_eigen(Z, K);
[labelU_a, C_a, ~] = litekmeans(U_a,K,'MaxIter',50,'Replicates',1);
bb = full(sum(C_a.*C_a,2)');
ab = full(U_o*C_a');
D = bb(ones(1,n),:) - 2*ab;
[dump, label1] = min(D, [], 2);
E = sparse(1:n,label1,1,n,K,n);  
C_o_pai = full((E*spdiags(1./sum(E,1)',0,K,K))'*U_o); 
[labelU_o, C_o, ~] = litekmeans(U_o,K,'MaxIter',50,'Replicates',1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  visualize 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        U_o = U_o(:,1:2);
        U_a = U_a(:,1:2);
        C_a = C_a(:,1:2);
        C_o_pai = C_o_pai(:,1:2);
        C_o = C_o(:, 1:2);
    for eee = 1:a
         plot(U_a(eee,1),U_a(eee,2),[config.cols{labelU_a(eee)},'x'],'markerfacecolor',config.cols{labelU_a(eee)})
        hold on
    end
    for eee = 1:n
        plot(U_o(eee,1),U_o(eee,2),[config.cols1{labelU_o(eee)},'.'],'markerfacecolor',config.cols1{labelU_o(eee)})
        hold on        
    end   
    scatter(C_a(:,1),C_a(:,2), 1000, 'r','p','filled');
     hold on
    scatter(C_o_pai(:,1),C_o_pai(:,2), 1000, 'k','o');
    hold on
    scatter(C_o(:,1),C_o(:,2), 1000, 'b','h','filled')
    hold off
disp('Algorithm Finished');



