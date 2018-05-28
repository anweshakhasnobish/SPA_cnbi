function [ eeg_data, eegBaseline_data ] = laplacian_filt(EEG)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    load('resources/laplacian_16_10-20_mi.mat');
    for index = 1:EEG.trials
        EEG.eeg(index,:,:) = squeeze(EEG.eeg(index,:,:))*lap;
        EEG.eegBaseline(index,:,:) = squeeze(EEG.eegBaseline(index,:,:))*lap;
    end
    
    eeg_data=EEG.eeg;                   % EEG data, [trials x samples(trial duration*fs) x number of electrodes]
    eegBaseline_data=EEG.eegBaseline;   % EEG Baseline data, [trials x samples(trial duration*fs) x number of electrodes]
end

