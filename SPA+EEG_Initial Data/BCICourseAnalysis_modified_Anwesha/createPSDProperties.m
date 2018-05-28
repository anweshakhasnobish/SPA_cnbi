function [grandAveragePSDProperties, epochPSDProperties] = createPSDProperties(EEG)
    loopFrequency = 16; % Hz
    grandAveragePSDProperties = struct('window', EEG.sampleRate, 'overlap', EEG.sampleRate / 2, ...
        'frequencies', 1:1:40);
    epochPSDProperties = struct('window', EEG.sampleRate, 'overlap', EEG.sampleRate / 2, ...
        'frequencies', 1:1:40, 'epochsPerTrial', 0, 'time', []);
    epochPSDProperties.overlap = floor(1/loopFrequency*EEG.sampleRate);
    epochPSDProperties.epochsPerTrial = floor((EEG.trialDuration - EEG.sampleRate)/ epochPSDProperties.overlap);
    epochPSDProperties.time = 0:epochPSDProperties.overlap:epochPSDProperties.epochsPerTrial*epochPSDProperties.overlap;
    epochPSDProperties.time = epochPSDProperties.time ./ EEG.sampleRate;
end