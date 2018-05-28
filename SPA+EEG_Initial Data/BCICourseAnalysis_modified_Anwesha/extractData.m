function EEG = extractData(filenames)
    global verbose;
    if verbose
       disp('Load data'); 
    end
    EEG = struct('eeg', [], 'eegBaseline', [],...
        'psd', [], 'psdEpochs', [], 'psdBaseline', [],'psdNormalized', [],...
        'labels', [], 'labelsEpochs', [],'trials', 0, 'epochs', 0, ...
        'nbChannels', 0, 'sampleRate', 0, 'trialDuration', Inf,...
        'baselineDuration', Inf);
    for filenameIndex = 1:length(filenames)
        trials = extractTrialsFromRun(filenames{filenameIndex});
        trials = truncEEGFromDurations(trials, EEG.trialDuration, ...
            EEG.baselineDuration);
        EEG = truncEEGFromDurations(EEG, trials.trialDuration, ...
            trials.baselineDuration);
        EEG.eeg         = cat(1, EEG.eeg, trials.eeg);
        EEG.eegBaseline = cat(1, EEG.eegBaseline, trials.eegBaseline);
        EEG.trials      = EEG.trials + trials.count;
        EEG.labels      = cat(1, EEG.labels, trials.labels);
        EEG.nbChannels  = trials.channels;
        EEG.sampleRate  = trials.sampleRate;
    end
end

function trials = extractTrialsFromRun(filename)
    [data, header] = sload(filename);
    data = data(:,1:end-1);
    data_0mean = ZeroMean(data);  % DC removal
    data_CAR = CAR(data_0mean);   % Common Average referencing
    data_bpf= BPFilter(data_CAR,4, 1, 48,512);  % band pass filtering: order=4, low_cutoff=0.1;, high_cutoff=48;
    data=data_bpf;
    trials = createTrialsFromSignalProperties(header);
    trials.eeg = NaN(trials.count, trials.trialDuration, header.NS-1);
    trials.eegBaseline = NaN(trials.count, trials.baselineDuration, header.NS-1);
    trials.eegSpectrogram = NaN(trials.count, ...
        trials.trialDuration + 7 * trials.sampleRate, header.NS-1);
    for index = 1:trials.count
        trials.eeg(index,:,:) = data(trials.starts(index):...
            (trials.starts(index) + trials.trialDuration-1),:);
        trials.eegBaseline(index,:,:) = data(trials.baselineStarts(index):...
            (trials.baselineStarts(index) + trials.baselineDuration-1),:);
    end
end

function trials = createTrialsFromSignalProperties(signalProperties)
    trials = struct('indices', [],'baselineIndices', [],...
        'count', 0, 'eeg', [], 'eegBaseline', [], 'eegSpectrogram', [],...
        'labels', [], 'starts', [], 'stops', [],...
        'baselineStarts', [], 'baselineStops', [], ...
        'trialDuration', 0, 'baselineDuration', 0,...
        'channels', 0, 'sampleRate', 0);
    trials.channels = signalProperties.NS-1;
    trials.sampleRate = signalProperties.SampleRate;
    trials.indices = find(signalProperties.EVENT.TYP == 781);
    trials.baselineIndices = find(signalProperties.EVENT.TYP == 786);
    trials.count = length(trials.indices);
    trials.labels = signalProperties.EVENT.TYP(trials.indices - 1);
    trials.starts = signalProperties.EVENT.POS(trials.indices);
    trials.stops = signalProperties.EVENT.POS(trials.indices) + ...
        signalProperties.EVENT.DUR(trials.indices) - 1;
    trials.trialDuration = min(unique(trials.stops - trials.starts));
    
    trials.baselineStarts = signalProperties.EVENT.POS(trials.baselineIndices);
    trials.baselineStops = signalProperties.EVENT.POS(trials.baselineIndices) + ...
        signalProperties.EVENT.DUR(trials.baselineIndices) - 1;
    trials.baselineDuration = min(unique(trials.baselineStops - trials.baselineStarts));
    if (trials.stops - trials.starts) < 0
       error('Stop of the trial should be after its start');
    end
end



function EEG = truncEEGFromDurations(EEG, trialsDuration, baselineDuration)
    EEG = truncEEGWithMinDuration(EEG, trialsDuration);
    EEG = truncBaselineWithMinDuration(EEG, baselineDuration);
end

function EEG = truncEEGWithMinDuration(EEG, currentMinDuration)
    if currentMinDuration < EEG.trialDuration
        EEG.trialDuration = currentMinDuration;
        if ~isempty(EEG.eeg)
            EEG.eeg = EEG.eeg(:,1:EEG.trialDuration,:);
        end
    end
end

function EEG = truncBaselineWithMinDuration(EEG, currentMinDurationBaseline)
    if currentMinDurationBaseline < EEG.baselineDuration
         EEG.baselineDuration = currentMinDurationBaseline;
        if ~isempty(EEG.eegBaseline)
            EEG.eegBaseline = EEG.eegBaseline(:,1:EEG.baselineDuration,:);
        end
    end
end