function classifier = buildClassifier_withFeat(EEG, Feature_data,labelsEpochs,classes)
    global verbose;
    if verbose, disp('Build Classifier'); end

%     data            = reshape(EEG.psdEpochs, ...
%         [size(EEG.psdEpochs,1) size(EEG.psdEpochs,2)*size(EEG.psdEpochs,3)]);
    data=Feature_data;
    labels          = labelsEpochs;
    partition       = rollPartition(6, size(data,1));
    testingResults  = NaN(partition.folds-1, size(data,2));
    trainingResults = NaN(partition.folds-1, size(data,2));
    featuresIndex   = NaN(partition.folds-1, size(data,2));
    for fold = 1:partition.folds-1
        if verbose, disp(['...Fold ' num2str(fold) '/' num2str(partition.folds-1)]);  end
        [crossValData, crossValLabels] = ...
            createClassificationDataFromPartition(data, labels, partition, fold);
        results = evaluateBestFeaturesForClassifier(crossValData, crossValLabels, classes);
        trainingResults(fold,:) = results.training;
        testingResults(fold,:) = results.testing;
        featuresIndex(fold,:) = results.rankedFeatures;
    end
    meanTestingError = nanmean(testingResults,1);
    meanTrainingError = nanmean(trainingResults,1);
    plotClassificationResults(meanTrainingError, meanTestingError)
    [value, indexFeature] = max(meanTestingError);
    bestFeatures = featuresIndex(1:indexFeature(1));

    model = fitcdiscr(...
        data(:,bestFeatures), ...
        labels, ...
        'DiscrimType', 'diagquadratic', ...
        'Gamma', 0, ...
        'FillCoeffs', 'off', ...
        'ClassNames', classes);
    classifier = struct('model', model, 'features', bestFeatures, 'data_bestFeats', data(:,bestFeatures), 'classify_labels', labels );
end

function [classificationData, classificationLabels] = ...
    createClassificationDataFromPartition(data, labels, partition, fold)
    classificationData = struct('training', data(partition.training(fold,:),:),...
        'testing',  data(partition.testing(fold,:),:));
    classificationLabels = struct('training', labels(partition.training(fold,:),:),...
        'testing', labels(partition.testing(fold,:),:));
end

function results = evaluateBestFeaturesForClassifier(data, labels, classes)
	results = struct('training',[], 'testing', [], 'rankedFeatures', []);
    [results.rankedFeatures,~] = rankfeat(data.training, labels.training, 'fisher');
    numberOfFeatures = length(results.rankedFeatures);
    results.training = NaN(1, numberOfFeatures);
    results.testing = NaN(1, numberOfFeatures);
    for featureIndex = 1:numberOfFeatures
        currentData = data;
        currentData.training = currentData.training(:,results.rankedFeatures(1:featureIndex));
        currentData.testing = currentData.testing(:,results.rankedFeatures(1:featureIndex));
        [results.training(featureIndex), results.testing(featureIndex)] = ...
            evaluateClassifier(currentData, labels, classes);
    end
end

function [trainError, testError] = evaluateClassifier(data, labels, classes)
    model = fitcdiscr(...
        data.training, ...
        labels.training, ...
        'DiscrimType', 'diagquadratic', ...
        'Gamma', 0, ...
        'FillCoeffs', 'off', ...
        'ClassNames', classes);
    trainError = sum(predict(model, data.training) == labels.training) /...
        length(labels.training);
    testError = sum(predict(model, data.testing) == labels.testing) /...
        length(labels.testing);
end

% function plotFeaturesDiscriminant(featuresIndex)
%     figure('Name', 'Classification Results', 'WindowStyle', 'docked'); clf;
%     plot(testingErrors);
%     hold on;
%     plot(trainingErrors);
% end

function plotClassificationResults(trainingErrors, testingErrors)
    figure('Name', 'Classification Results', 'WindowStyle', 'docked'); clf;
    plot(testingErrors);
    hold on;
    plot(trainingErrors);
end