function plotSpectrogram(EEG, classes, psdProperties, channelLabels)
    global verbose;
    if verbose, disp('Plot Spectrogram'); end
%     plotSpectrogramMethod1(EEG, classes, psdProperties, chanlocs16);
    plotSpectrogramMethod2(EEG, classes, psdProperties, channelLabels);
end

function plotSpectrogramMethod2(EEG, classes, psdProperties, channelLabels)
    epochPSD =reshape(EEG.psdEpochs,...
        EEG.epochs/EEG.trials,...
        EEG.trials,...
        length(psdProperties.frequencies),...
        EEG.nbChannels);
    for trial = 1:EEG.trials
        for epoch = 1:EEG.epochs/EEG.trials
            epochPSD(epoch,trial,:,:) = squeeze(epochPSD(epoch,trial,:,:))./squeeze(EEG.psdBaseline(trial,:,:));
        end
    end
    class1PSD = 10*log10(squeeze(median(epochPSD(:,EEG.labels == classes(1),:,:),2)));
    class2PSD = 10*log10(squeeze(median(epochPSD(:,EEG.labels == classes(2),:,:),2)));
    diffClassPSD = class2PSD - class1PSD;
    figure('Name', 'Spectrogram Class 1', 'WindowStyle', 'docked');
    plotSpectrogramForClass(permute(class1PSD,[2,1,3]), psdProperties, channelLabels)
    figure('Name', 'Spectrogram Class 2', 'WindowStyle', 'docked');
    plotSpectrogramForClass(permute(class2PSD,[2,1,3]), psdProperties, channelLabels)
    figure('Name', 'Spectrogram Class difference', 'WindowStyle', 'docked');  
    plotSpectrogramForClass(permute(diffClassPSD,[2,1,3]), psdProperties, channelLabels)
end

function plotSpectrogramMethod1(EEG, classes, psdProperties, chanlocs16)
    windowDivider = 1;
    nbWindows = round(2*length(EEG.eegSpectrogram(1,:,1)) / psdProperties.window * windowDivider) - 2;
    [psd, time, frequencies] = extractSpectrogramPSD(EEG, psdProperties);

    class1 = mean(psd(EEG.labels == classes(1),:,:,:),1);
    class2 = mean(psd(EEG.labels == classes(2),:,:,:),1);
    figure('Name', 'Spectrogram Class 1', 'WindowStyle', 'docked');
    plotSpectrogramForClass(squeeze(class1), time, frequencies, {chanlocs16.labels})
    figure('Name', 'Spectrogram Class 2', 'WindowStyle', 'docked');
    plotSpectrogramForClass(squeeze(class2), time, frequencies, {chanlocs16.labels})
    figure('Name', 'Spectrogram Class difference', 'WindowStyle', 'docked');  
    plotSpectrogramForClass(squeeze(abs(class2-class1)), time, frequencies, {chanlocs16.labels})
end

function [psd, time, frequencies] = extractSpectrogramPSD(EEG, psdProperties)
    nbWindows = 319;
    psd         = NaN(EEG.trials,length(psdProperties.frequencies), nbWindows, EEG.nbChannels);
    for channel = 1:EEG.nbChannels
        for trial = 1:EEG.trials
            [psd(trial,:,:,channel), time, frequencies] = ...
                extractSpectrogramPSDForTrial(...
                EEG.eegSpectrogram(trial,:,channel), ...
                EEG.eegBaseline(trial,:,channel), ...
                psdProperties, ...
                EEG.sampleRate);
        end
    end
end

function [psd, time, frequencies] = extractSpectrogramPSDForTrial(trial, baseline, psdProperties, sampleRate)
    [~,~,~,baselinePSD] = spectrogram(baseline, psdProperties.window, ...
        psdProperties.window - 16, psdProperties.frequencies, sampleRate, 'power');
    [~,frequencies,time,psd] = ...
        spectrogram(trial,psdProperties.window, ...
        psdProperties.window - 16, psdProperties.frequencies, sampleRate, 'power');
    psd = 10*log10(psd ./ mean(baselinePSD,2));

end

function plotSpectrogramForClass(classPSD, properties, channelLabels)
    for channel = 1:length(channelLabels)
        plotSpectrogramFromChannel(classPSD(:,:,channel), properties, channel, channelLabels(channel))
    end
end

function plotSpectrogramFromChannel(timeFrequenciesSeries, properties, channel, channelLabel)
    selectSubplotFromChannel(channel)
    imagesc('XData', properties.time, 'YData', properties.frequencies, 'CData', timeFrequenciesSeries);
    if channel == 1 || channel == 2 || channel == 7 || channel == 12
        ylabel('Frequency (Hz)') 
    else
        set(gca,'yticklabel',[])
    end
    if channel == 12 || channel == 13 || channel == 14 || channel == 15 || channel == 16
        xlabel('Times (s)')
    else
        set(gca,'xticklabel',[])
    end
    title(channelLabel);
    caxis([-15 15])
    xlim([min(properties.time) max(properties.time)])
    ylim([min(properties.frequencies) max(properties.frequencies)])
    line([0 0], [min(properties.frequencies) max(properties.frequencies)],'LineWidth',2);
    colormap jet;
end

function selectSubplotFromChannel(channel)
    if channel == 1
        subplot(4,5,3);
    else
        subplot(4,5,4+channel);
    end
end