function [Fz_epoch,FC3_epoch,FC1_epoch,FCz_epoch,FC2_epoch,FC4_epoch,C3_epoch,C1_epoch,...
          Cz_epoch,C2_epoch,C4_epoch,CP3_epoch,CP1_epoch,CPz_epoch,CP2_epoch,CP4_epoch,labelsEpochs] ...
                                        = eegEpochData_electrode(EEG, EEG_data)
% divides the electrode wise data according to the epochs, i.e, according
% to the loop frequency
%   Detailed explanation goes here

 [Fz,FC3,FC1,FCz,FC2,FC4,C3,C1,Cz,C2,C4,CP3,CP1,CPz,CP2,CP4]= eegData_electrode(EEG_data);
 
 loopFrequency=16;
 window=EEG.sampleRate;
 overlap= floor(1/loopFrequency*EEG.sampleRate);
 epochsPerTrial=floor((EEG.trialDuration - EEG.sampleRate)/overlap);
 epoch_time =0:overlap:epochsPerTrial*overlap;
 epoch_time=epoch_time ./ EEG.sampleRate;
 
 labelsEpochs=[];
 Fz_epoch=[];FC3_epoch=[];FC1_epoch=[];FCz_epoch=[];FC2_epoch=[];FC4_epoch=[];
 C3_epoch=[];C1_epoch=[];Cz_epoch=[];C2_epoch=[];C4_epoch=[];CP3_epoch=[];
 CP1_epoch=[];CPz_epoch=[];CP2_epoch=[];CP4_epoch=[];
 
 clear trialIndex epochs
   for trialIndex= 1:(EEG.trials)
    for epochs = 0:epochsPerTrial-1
        stopEpoch = overlap*(epochs + 1)+window;
        if stopEpoch > size(EEG_data,2)
            stopEpoch = size(EEG_data,2);
        end
        epochs = epochs + 1;
        labelsEpochs_temp(epochs) = EEG.labels(trialIndex);
            FzTemp(epochs,:)  = Fz(trialIndex,(overlap * epochs + 1):stopEpoch);
            FC3Temp(epochs,:)  = FC3(trialIndex,(overlap * epochs + 1):stopEpoch);
            FC1Temp(epochs,:)  = FC1(trialIndex,(overlap * epochs + 1):stopEpoch);
            FCzTemp(epochs,:)  = FCz(trialIndex,(overlap * epochs + 1):stopEpoch);
            FC2Temp(epochs,:)  = FC2(trialIndex,(overlap * epochs + 1):stopEpoch);
            FC4Temp(epochs,:)  = FC4(trialIndex,(overlap * epochs + 1):stopEpoch);
            C3Temp(epochs,:)  = C3(trialIndex,(overlap * epochs + 1):stopEpoch);
            C1Temp(epochs,:)  = C1(trialIndex,(overlap * epochs + 1):stopEpoch);
            CzTemp(epochs,:)  = Cz(trialIndex,(overlap * epochs + 1):stopEpoch);
            C2Temp(epochs,:)  = C2(trialIndex,(overlap * epochs + 1):stopEpoch);
            C4Temp(epochs,:)  = C4(trialIndex,(overlap * epochs + 1):stopEpoch);
            CP3Temp(epochs,:)  = CP3(trialIndex,(overlap * epochs + 1):stopEpoch);
            CP1Temp(epochs,:)  = CP1(trialIndex,(overlap * epochs + 1):stopEpoch);
            CPzTemp(epochs,:)  = CPz(trialIndex,(overlap * epochs + 1):stopEpoch);
            CP2Temp(epochs,:)  = CP2(trialIndex,(overlap * epochs + 1):stopEpoch);
            CP4Temp(epochs,:)  = CP4(trialIndex,(overlap * epochs + 1):stopEpoch);
    end
 Fz_epoch=[Fz_epoch;FzTemp];FC3_epoch=[FC3_epoch;FC3Temp];FC1_epoch=[FC1_epoch;FC1Temp];FCz_epoch=[FCz_epoch;FCzTemp];
 FC2_epoch=[FC2_epoch;FC2Temp];FC4_epoch=[FC4_epoch;FC4Temp];C3_epoch=[C3_epoch;C3Temp];C1_epoch=[C1_epoch;C1Temp];
 Cz_epoch=[Cz_epoch;CzTemp];C2_epoch=[C2_epoch;C2Temp];C4_epoch=[C4_epoch;C4Temp];CP3_epoch=[CP3_epoch;CP3Temp];
 CP1_epoch=[CP1_epoch;CP1Temp];CPz_epoch=[CPz_epoch;CPzTemp];CP2_epoch=[CP2_epoch;CP2Temp];CP4_epoch=[CP4_epoch;CP4Temp];
 
 labelsEpochs=[labelsEpochs;labelsEpochs_temp'];
 
 clear FzTemp FC3Temp FC1Temp FCzTemp FC2Temp FC4Temp C3Temp C1Temp CzTemp C2Temp C4Temp CP3Temp ...
     CP1Temp CPzTemp CP2Temp CP4Temp labelsEpochs_temp
 
   end

end

