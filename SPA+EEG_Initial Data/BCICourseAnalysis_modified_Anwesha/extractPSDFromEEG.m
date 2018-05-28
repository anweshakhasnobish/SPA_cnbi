function EEG = extractPSDFromEEG(EEG, psdProperties, epochPSDProperties)
    global verbose
    if verbose
       disp('Extract PSD'); 
    end
    EEG.psd = NaN(length(EEG.trials), length(psdProperties.frequencies), EEG.nbChannels);
    EEG.psdEpochs = NaN(epochPSDProperties.epochsPerTrial, length(psdProperties.frequencies), EEG.nbChannels);
    EEG.psdBaseline = NaN(length(EEG.trials), length(psdProperties.frequencies), EEG.nbChannels);
    
    for trialIndex = 1:(EEG.trials)
        EEG = extractPSDFromTrial(EEG, trialIndex, psdProperties);
        EEG = extractEpochFromTrial(EEG, trialIndex, epochPSDProperties);
    end
    EEG.labelsEpochs = EEG.labelsEpochs';
    % Normalize trial psd with baseline psd
    EEG.psdNormalized = 10*log10(EEG.psd ./ abs(EEG.psdBaseline));
end

function EEG = extractPSDFromTrial(EEG, trialIndex, psdProperties)
    for channel = 1:EEG.nbChannels
        [EEG.psd(trialIndex,:,channel),~] = pwelch(EEG.eeg(trialIndex,:,channel), ...
            psdProperties.window, psdProperties.overlap, psdProperties.frequencies, ...
            EEG.sampleRate,'power');
        [EEG.psdBaseline(trialIndex,:,channel),~] = ...
            pwelch(EEG.eegBaseline(trialIndex,:,channel), ...
            psdProperties.window, psdProperties.overlap, psdProperties.frequencies,...
            EEG.sampleRate,'power');
    end
end

function EEG = extractEpochFromTrial(EEG, trialIndex, epochPSDProperties)
    for epoch = 0:epochPSDProperties.epochsPerTrial-1
        stopEpoch = epochPSDProperties.overlap*(epoch + 1)+epochPSDProperties.window;
        if stopEpoch > size(EEG.eeg,2)
            stopEpoch = size(EEG.eeg,2);
        end
        EEG.epochs = EEG.epochs + 1;
        EEG.labelsEpochs(EEG.epochs) = EEG.labels(trialIndex);
        for channel = 1:EEG.nbChannels
            [EEG.psdEpochs(EEG.epochs,:,channel),~] = ...
                pwelch(EEG.eeg(trialIndex,(epochPSDProperties.overlap * epoch + 1):stopEpoch,channel), ...
                epochPSDProperties.window, ...
                epochPSDProperties.overlap, ...
                epochPSDProperties.frequencies, ...
                EEG.sampleRate); 
        end
    end
end