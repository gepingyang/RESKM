
clear;
load('./dataset/USPS.mat');
fea = double(fea);
fea = full(fea);
n = size(fea,1);
opts.r =2 ;     % the number of nearest anchors .
opts.a = 600;    % the number of anchors.
opts.s = 3400;   % the number of sampled object to perform a-means anchor selection.
t = 10;     % Number of times to repeat the clustering of anchor k-means, each with new set of initial centroids.
K = 10;        % the number of clusters.
% configuration
seed.start = 1;
seed.end = 10;
interval = seed.end - seed.start + 1;

time_max = 0;
time_all_sum = 0;
time_construct_sum = 0;
time_kmeans_sum = 0;
time_eign_sum = 0; 
sampling_all = 0;

nmi_max = 0;
nmi_sum = 0;
ac_max = 0;
ac_sum = 0;


for i = seed.start : seed.end    
    rand('seed',i);    
    fprintf('Seed No: %d\n',i);
    
%step 1: Select Anchors 
    tic;
    [anchors] = anchorselection(fea, opts);
    time_sampling = toc;
    sampling_all  = sampling_all + time_sampling;
%step 2: Construct Graph   
    tic;
    [Z] = construction(fea, anchors, opts);
    clear anchors;
    time_construct = toc;
    time_construct_sum = time_construct_sum + time_construct;
    
%step 3: Compute the eignvector of anchor space
    tic;        
    [ U_o,U_a] = cal_eigen(Z,K);  

    time_eign = toc;        
    time_eign_sum = time_eign_sum +time_eign;
    
    clear Z;
    
%step 4: Perform kmeans
    tic;
    [labels,center]=litekmeans(U_a,K,'MaxIter', 100, 'Replicates', t);
    bb = full(sum(center.*center,2)');
    ab = full(U_o*center');
    D = bb(ones(1,n),:) - 2*ab;
    [dump, label] = min(D, [], 2);

    clear U_a dump labels U_o

    time_kmeans = toc;
    time_kmeans_sum = time_kmeans_sum + time_kmeans;
    label = bestMap(gnd,label);
    nmi_result = nmi(label,gnd);  
    ac_result = length(find(gnd == label))/length(gnd);
    

    
% Update record
    per_runtime = time_construct + time_eign + time_kmeans + time_sampling;
    fprintf('NMI: %.2f%%\n',nmi_result * 100);
    fprintf('AC: %.2f%%\n',ac_result * 100);
    fprintf('Runtime of Four Phases:\n');
    fprintf('anchor: %f s + ', time_sampling);
    fprintf('graph: %f s + ', time_construct );
    fprintf('egien: %f s + ', time_eign);
    fprintf('kmeans: %f s \n', time_kmeans);
    fprintf('Runing Time: %f s\n\n\n', per_runtime);
    if (nmi_result > nmi_max)
        nmi_max = nmi_result;
    end    
    if (ac_result>ac_max)
        ac_max = ac_result;
    end    
    if (per_runtime >time_max)
        time_max = per_runtime;
    end
    
    nmi_sum = nmi_sum + nmi_result;
    ac_sum = ac_sum + ac_result;   
    time_all_sum = time_all_sum + per_runtime;
    clear ac_result nmi_result per_runtime time_construct time_kmeans time_eign;
end
nmi_avg = nmi_sum / interval;
ac_avg = ac_sum / interval;
time_eign_avg = time_eign_sum /interval;
time_kmeans_avg = time_kmeans_sum / interval;
time_construct_avg = time_construct_sum / interval;
sampling_avg = sampling_all / interval;
time_avg = time_all_sum / interval;
fprintf('Avg Runtime of Four Phases:\n');
fprintf('avg_anchor: %f s + ', sampling_avg);
fprintf('avg_graph: %f s + ', time_construct_avg);
fprintf('avg_egien_: %f s + ', time_eign_avg);
fprintf('avg_kmeans: %f s \n', time_kmeans_avg);
fprintf('avg_nmi: %.2f%% + ', nmi_avg * 100);
fprintf('max_nmi: %.2f%%\n', nmi_max * 100);
fprintf('avg_ac: %.2f%% + ', ac_avg * 100);
fprintf('max_ac: %.2f%%\n', ac_max * 100);
fprintf('avg_total_time: %.2f s\n\n\n', time_avg)

clear nmi_sum ac_sum time_eign_sum time_kmeans_sum time_construct_sum time_all_sum S;
clear ac_array ac_max_seed nmi_array nmi_max_seed time_array

disp('Algorithm Finished');
