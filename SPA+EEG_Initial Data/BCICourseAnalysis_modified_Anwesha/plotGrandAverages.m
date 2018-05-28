function plotGrandAverages(EEG, classes, psdPropeties, chanlocs16)
    global verbose;
    if verbose, disp('Plot data'); end
    [psdClass1, psdClass2] = getGrandAveragePSD(EEG, psdPropeties.frequencies, classes);
    if verbose, disp('...Plot grand average'); end
    plotClassesGrandAverage(psdClass1, psdClass2, psdPropeties.frequencies, {chanlocs16.labels})
    if verbose, disp('...Topoplot grand average'); end
    topoplotGrandAverages(psdClass1, psdClass2, psdPropeties.frequencies, chanlocs16)
end

function [psdClass1, psdClass2] = getGrandAveragePSD(EEG, frequencies, classes)
    psdClass1 = getGrandAveragePSDFromClass(EEG, frequencies, classes(1));
    psdClass2 = getGrandAveragePSDFromClass(EEG, frequencies, classes(2));
end

function psd = getGrandAveragePSDFromClass(EEG, frequencies, label)
    grandAveragePSD = nanmean(EEG.psdNormalized(EEG.labels == label, :,:),1);
    psd = reshape(grandAveragePSD,[length(frequencies), size(grandAveragePSD,3)]);
end

function plotClassesGrandAverage(grandAveragePSDClassR1, grandAveragePSDClassR2,...
    frequencies, channelLabels)
    figure('Name', 'Grand Average', 'WindowStyle', 'docked'); clf;
    subplot(2,2,1)
    plotGrandAverage(grandAveragePSDClassR1', frequencies, channelLabels, ...
        'PSD for Class 1');
    subplot(2,2,2)
    plotGrandAverage(grandAveragePSDClassR2', frequencies, channelLabels, ...
        'PSD for Class 2');
    subplot(2,2,3)
    diffPSDClasses = abs(grandAveragePSDClassR1' - grandAveragePSDClassR2');
    plotGrandAverage(diffPSDClasses, frequencies, channelLabels, ...
        'PSD absolute difference between class 1 and 2');
end

function plotGrandAverage(grandAverage, frequencies, channels, plotTitle)
    imagesc(frequencies, 1:length(channels), grandAverage);
    xlabel('Frequency [hz]')
    ylabel('Channel')
    title(plotTitle)  
    colormap jet;
    colorbar
%     yticks(1:length(channels));
%     yticklabels(channels)
    caxis([-10 10])
end

function topoplotGrandAverages(grandAveragePSDClassR1, grandAveragePSDClassR2,...
    frequencies, chanlocs16)
    figure('Name', 'Topoplot 1', 'WindowStyle', 'docked'); clf;
    topoplotGrandAverage(grandAveragePSDClassR1, frequencies, chanlocs16);
    figure('Name', 'Topoplot 2', 'WindowStyle', 'docked'); clf;
    topoplotGrandAverage(grandAveragePSDClassR2, frequencies, chanlocs16);
    drawnow();
end

function topoplotGrandAverage(grandAverage, frequencies, chanlocs16)
    for frequency = 1:length(frequencies)
        subplot(4,ceil(length(frequencies)/4),frequency);
        topoplot(grandAverage(frequency,:), chanlocs16);
        title([num2str(frequencies(frequency)) 'Hz']);
    end
end

