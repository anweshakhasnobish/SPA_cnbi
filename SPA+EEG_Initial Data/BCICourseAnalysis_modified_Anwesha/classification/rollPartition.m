function partition = rollPartition(folds, lengthData)
%ROLLPARTITION Create a roll partition following this descrition: 
% https://stats.stackexchange.com/questions/14099/using-k-fold-cross-validation-for-time-series-model-selection
    partition           = struct();
    partition.folds     = folds;
    partition.training  = zeros(folds-1, lengthData);
    partition.testing   = zeros(folds-1, lengthData);
    rollingTime         = floor(lengthData/folds);
    for fold = 1:folds-1
        partition.training(fold, 1:fold*rollingTime) = 1;
        partition.testing(fold, fold*rollingTime+1:(fold + 1)*rollingTime) = 1;
    end
    partition.training = logical(partition.training);
    partition.testing = logical(partition.testing);
end