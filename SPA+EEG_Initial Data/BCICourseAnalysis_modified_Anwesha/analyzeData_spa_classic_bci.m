clear all;
global verbose;
verbose = true;

initializePaths();
filenames = {'anonymous.20180305.103211.offline.mi.mi_hand.gdf',...
    'anonymous.20180305.104344.offline.mi.mi_hand.gdf'};
reload = true;

if ~exist('tmp/EEG.mat','file') || reload
    EEG = extractData(filenames);       % extract the EEG data from the gdf file, according to events and other info

   %[eeg_data, eegBaseline_data]  = laplacian_filt(EEG); % Laplacian filtering
   
   % NOTE: either use Laplacian on CAR. CAR is inside function "extractData"
    
    eeg_data=EEG.eeg;                   % EEG data, [trials x samples(trial duration*fs) x number of electrodes]
    eegBaseline_data=EEG.eegBaseline;   % EEG Baseline data, [trials x samples(trial duration*fs) x number of electrodes]
    classes=EEG.labels;
    class_label=unique(classes);
    class_1_ind=find(classes==class_label(1));
    class_2_ind=find(classes==class_label(2));
    
    
    
    samplerate=EEG.sampleRate;   
    window_len=samplerate;
    overlapPercnt=0.5*window_len; 
    freq_start=5;
    freq_resol=1;
    freq_end=45;
    freq_range=freq_start:freq_resol:freq_end;
    % PSD features for baseline
    [psdAVG_allElectrode_Baseline,Feat_psdAll_trial_Baseline] = PSDfeature_exatraction(EEG, eegBaseline_data,samplerate,...
                          window_len,overlapPercnt,freq_range);
    %PSD features for EEG data                    
   [psdAVG_allElectrode_eeg,Feat_psdAll_trial_eeg,labelsEpochs] = PSDfeature_exatraction(EEG, eeg_data,samplerate,...
                            window_len,overlapPercnt,freq_range);
   % Normalized PSD                     
   psdNormalized = 10*log10( psdAVG_allElectrode_eeg./ abs(psdAVG_allElectrode_Baseline));
   
   %ERPs
%    [erp_class_1,erp_class_2]= erp_eeg(eeg_data, class_1_ind, class_2_ind, samplerate);
   
   [grandAveragePSDProperties, epochPSDProperties] = createPSDProperties(EEG);
%     EEG = extractPSDFromEEG(EEG, grandAveragePSDProperties, epochPSDProperties);
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
 classifier = buildClassifier_withFeat(EEG,Feat_psdAll_trial_eeg,labelsEpochs,classes);
[label_pred score_pred cost_pred] = predict(classifier.model,classifier.data_bestFeats);
classifier_metrics = classifierMetric(classifier.classify_labels, label_pred );
