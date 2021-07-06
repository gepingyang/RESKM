function [C, U1] = cal_gigen(Z, K) 
[nSmp, mFea] = size(Z);
MAX_MATRIX_SIZE = 1600; % You can change this number according your machine computational power
EIGVECTOR_RATIO = 0.1; % You can change this number according your machine computational power
ReducedDim = K +1 ;
ddata = Z'*Z;
% ddata = ddata * ddata;
ddata = max(ddata,ddata');
dimMatrix = size(ddata,1);
 if (ReducedDim > 0) && (dimMatrix > MAX_MATRIX_SIZE) && (ReducedDim < dimMatrix*EIGVECTOR_RATIO)
    option = struct('disp',0);
    [U, eigvalue] = eigs(ddata,ReducedDim,'la',option);
    eigvalue = diag(eigvalue);
else
    if issparse(ddata)
        ddata = full(ddata);
    end

    [U, eigvalue] = eig(ddata);
%     option = struct('disp',0);
%     [U, eigvalue] = eigs(ddata,Z' * Z,ReducedDim,'lm',option);
    eigvalue = diag(eigvalue);
    [dump, index] = sort(-eigvalue);
    eigvalue = eigvalue(index);
    U = U(:, index);
 end
  maxEigValue = max(abs(eigvalue));
eigIdx = find(abs(eigvalue)/maxEigValue < 1e-10);
eigvalue(eigIdx) = [];
U(:,eigIdx) = [];

if (ReducedDim > 0) && (ReducedDim < length(eigvalue))
    eigvalue = eigvalue(1:ReducedDim);
    U = U(:,1:ReducedDim);
end

eigvalue_Half = eigvalue.^.5;
eigvalue_MinusHalf = eigvalue_Half.^-1;



%     clear Z;

%step 4: Perform kmeans

U(:,1) = [];
eigvalue_MinusHalf(1) = [];
% U1 = U;
U1 = U.*repmat(eigvalue_MinusHalf',size(U,1),1);
%                         U1 = U1 ./repmat(sqrt(sum(U1.^2,2)),1,K);
C = Z * U1;%( U.*repmat(eigvalue_MinusHalf',size(U,1),1));
C = C ./repmat(sqrt(sum(C.^2,2)),1,K);
U1 = U1 ./repmat(sqrt(sum(U1.^2,2)),1,K);