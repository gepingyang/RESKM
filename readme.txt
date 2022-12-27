source of the paper 
' RESKM: A general framework to accelerate large-scale spectral clustering'
# Environment
MATLAB R2018b
#Run
Run 'demoRESKM.m'

'anchorselection.m'denotes the anchor selection mode.
'construction.m' denotes the graph construction mode.
'cal_eigen.m' denotes the eigen decomposition mode.
'litekmeans.m' denotes the  a-means\k-means  algorithm mode.
'baseline' folder denotes the compared mthods of the paper
figure' folder denotes correlated figure of the paper

If you find this code useful for your research, please cite
@article{YANG2022109275,
title = {RESKM: A General Framework to Accelerate Large-Scale Spectral Clustering},
journal = {Pattern Recognition},
pages = {109275},
year = {2022},
issn = {0031-3203},
doi = {https://doi.org/10.1016/j.patcog.2022.109275},
url = {https://www.sciencedirect.com/science/article/pii/S0031320322007543},
author = {Geping Yang and Sucheng Deng and Xiang Chen and Can Chen and Yiyang Yang and Zhiguo Gong and Zhifeng Hao},
keywords = {Machine Learning, Spectral clustering, Unsupervised learning, Large-scale},
abstract = {Spectral Clustering is an effective preprocessing method in communities for its excellent performance, but its scalability still is a challenge. Many efforts have been made to face this problem, and several solutions are proposed, including Nyström Approximation, Sparse Representation Approximation, etc. However, according to our survey, there is still a large room for improvement. This work thoroughly investigates the factors relevant to large-scale Spectral Clustering and proposes a general framework to accelerate Spectral Clustering by utilizing the Robust and Efficient Spectral k-Means (RESKM). The contributions of RESKM are three folds: (1) a unified framework is proposed for large-scale Spectral Clustering; (2) it consists of four phases, each phase is theoretically analyzed, and the corresponding acceleration is suggested; (3) the majority of the existing large-scale Spectral Clustering methods can be integrated into RESKM and therefore be accelerated. Experiments on datasets with different scalability demonstrate that the robustness and efficiency of RESKM.}
}
