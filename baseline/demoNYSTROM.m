clear;
load('../dataset/USPS.mat');
fea = double(fea);
fea = full(fea);
K = 10;% the number of clusters.
a = 600; % the number of anchors 
simga = 4; %bandwidth parameter
% configuration
seed.start = 1;
seed.end = 10;
interval = seed.end - seed.start + 1;

time_max = 0;
time_all_sum = 0;
time_construct_sum = 0;
time_sampling_sum  = 0;
time_kmeans_sum = 0;
time_eign_sum = 0; 
nmi_result = 0;       
ac_result = 0;          

nmi_max = 0;
nmi_sum = 0;
ac_max = 0;
ac_sum = 0;

for i = seed.start : seed.end    
    rand('seed',i);    
    fprintf('Seed No: %d\n',i);
     [label,time_sampling, time_eign, time_construct, time_kmeans] = nystrom(fea, a,  simga, K);
     time_all = time_sampling + time_construct + time_eign + time_kmeans;
     time_all_sum = time_sampling + time_construct + time_eign + time_kmeans + time_all_sum;

    time_construct_sum = time_construct + time_construct_sum;
    time_eign_sum = time_eign + time_eign_sum; 
    time_kmeans_sum = time_kmeans_sum + time_kmeans;
    time_sampling_sum = time_sampling + time_sampling_sum;
    label = bestMap(gnd,label);

    nmi_result = nmi(label,gnd);

    ac_result = length(find(gnd == label))/length(gnd);

    fprintf('NMI: %.2f%%\n',nmi_result * 100);
    fprintf('AC: %.2f%%\n',ac_result * 100);
    fprintf('Runtime of Four Phases:\n');
    fprintf('anchor: %f s + ', time_sampling);
    fprintf('graph: %f s + ', time_construct);
    fprintf('egien: %f s + ', time_eign);
    fprintf('kmeans: %f s \n', time_kmeans);
    fprintf('Runing Time: %f s\n\n\n', time_all);

    if (nmi_result > nmi_max)
        nmi_max = nmi_result;
    end    
    if (ac_result>ac_max)
        ac_max = ac_result;
    end 
    nmi_sum = nmi_sum + nmi_result;
    ac_sum = ac_sum + ac_result;
                        
clear ac_result nmi_result per_runtime time_construct time_kmeans time_eign;
end

nmi_avg = nmi_sum / interval
ac_avg = ac_sum / interval;
time_eign_avg = time_eign_sum /interval;
time_kmeans_avg = time_kmeans_sum / interval;
time_avg = time_all_sum / interval;
sampling_avg = time_sampling_sum/ interval;
time_construct_avg = time_construct_sum / interval;
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
clear nmi_sum ac_sum time_eign_sum time_kmeans_sum time_construct_sum time_all_sum ;

disp('Algorithm Finished');