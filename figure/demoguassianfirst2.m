clear;
load('./dataset/guassian.mat');
%drawing  figure1(a) 
K = 4;
[n, p] = size(fea);
config.cols = {'y','m','c','g'};
config.cols1 = {'m','c','y' ,'g'}
rand('seed',1);    
r =3;
a = 200;
s = 600;
%step 1: anchor selection
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
Z = repmat(D_a,1,a).* Z .* repmat(D_o,n, 1);
clear H            
%step 3: Compute the eignvector of anchor space
[U_o, U_a] = cal_eigen(Z, K);
clear Z
%step4 ; Compute the correlated centers and labels
[labelU_a, C_a, ~] = litekmeans(U_a,K,'MaxIter',100,'Replicates',1);
bb = full(sum(C_a.*C_a,2)');
ab = full(U_o*C_a');
D = bb(ones(1,n),:) - 2*ab;
[dump, label1] = min(D, [], 2);
 E = sparse(1:n,label1,1,n,K,n);  % transform label into indicator matrix
C_o_pai = full((E*spdiags(1./sum(E,1)',0,K,K))'*U_o);    % compute C_o'
[labelU_o, C_o, ~] = litekmeans(U_o,K,'MaxIter',100,'Replicates',1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  visualize 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
C1 = U_o(:,1:2);
U1 = U_a(:,1:2);
C_a = C_a(:,1:2);
C_o = C_o(:,1:2);
C_o_pai = C_o_pai(:, 1:2);
for eee = 1:a

     plot(U1(eee,1),U1(eee,2),[config.cols1{labelU_a(eee)},'x'],'markerfacecolor',config.cols1{labelU_a(eee)})
    hold on                               
end

for eee = 1:n
    plot(C1(eee,1),C1(eee,2),[config.cols{labelU_o(eee)},'.'],'markerfacecolor',config.cols{labelU_o(eee)})
    hold on        
end
scatter(C_a(:,1),C_a(:,2), 1000, 'r','p','filled');
 hold on
scatter(C_o_pai(:,1),C_o_pai(:,2), 1000, 'k','o');
hold on
scatter(C_o(:,1),C_o(:,2), 1000, 'b','h','filled')
hold off
disp('Algorithm Finished');


