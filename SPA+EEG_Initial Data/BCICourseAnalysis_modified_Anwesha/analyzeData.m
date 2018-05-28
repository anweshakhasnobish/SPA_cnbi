clear all;
global verbose;
verbose = true;

initializePaths();
filenames = {'anonymous.20180305.103211.offline.mi.mi_hand.gdf',...
    'anonymous.20180305.104344.offline.mi.mi_hand.gdf'};
reload = true;
load('resources/laplacian_16_10-20_mi.mat');
if ~exist('tmp/EEG.mat','file') || reload
    EEG = extractData(filenames);
    for index = 1:EEG.trials
        EEG.eeg(index,:,:) = squeeze(EEG.eeg(index,:,:))*lap;
        EEG.eegBaseline(index,:,:) = squeeze(EEG.eegBaseline(index,:,:))*lap;
    end
%     EEG.eeg = EEG.eeg - mean(EEG.eeg,3);
%     EEG.eegBaseline = EEG.eegBaseline - mean(EEG.eegBaseline,3);
    [grandAveragePSDProperties, epochPSDProperties] = createPSDProperties(EEG);
    EEG = extractPSDFromEEG(EEG, grandAveragePSDProperties, epochPSDProperties);
    save('tmp/EEG.mat','EEG');
else
    load('tmp/EEG.mat');
    [grandAveragePSDProperties, epochPSDProperties] = createPSDProperties(EEG);
end
load('channel_location_16_10-20_mi.mat');
classes = [782, 783];
% plotGrandAverages(EEG, classes, grandAveragePSDProperties, chanlocs16);
% plotSpectrogram(EEG, classes, epochPSDProperties, {chanlocs16.labels});

%% Building classifier
classifier = buildClassifier(EEG, classes);


