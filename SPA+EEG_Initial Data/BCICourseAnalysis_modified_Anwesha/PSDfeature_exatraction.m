function [ psdAVG_allElectrode,Feat_psdAll_trial,labelsEpochs] = PSDfeature_exatraction(EEG,EEG_data,samplerate,window_len,overlapPercnt,freq_range)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   
   %electrode wise data extraction, rows are the trials
%    [Fz,FC3,FC1,FCz,FC2,FC4,C3,C1,Cz,C2,C4,CP3,CP1,CPz,CP2,CP4 ] = eegData_electrode(EEG_data);
   
    %electrode wise data extraction, 
    %rows are the (no. of trials * no. of epochs per trial)
   [Fz,FC3,FC1,FCz,FC2,FC4,C3,C1,Cz,C2,C4,CP3,CP1,CPz,CP2,CP4,labelsEpochs] = eegEpochData_electrode(EEG,EEG_data);
   
%    [trialNum sampleNum electrodeNum]=size(eeg_data);

% samplerate=EEG.sampleRate;   
% window_len=samplerate/2;
% overlapPercnt=0.5;
% freq_start=5;
% freq_resol=1;
% freq_end=45;
    
   
 
    % PSD EEG-trials
    clear i freq
   for i=1:size(Fz,1) % trial wise PSD for every electrode-wise data
    psdFz(i,:)=pwelch(Fz(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate); 
    psdFC3(i,:)=pwelch(FC3(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdFC1(i,:)=pwelch(FC1(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdFCz(i,:)=pwelch(FCz(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdFC2(i,:)=pwelch(FC2(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdFC4(i,:)=pwelch(FC4(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdC3(i,:)=pwelch(C3(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdC1(i,:)=pwelch(C1(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdCz(i,:)=pwelch(Cz(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdC2(i,:)=pwelch(C2(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdC4(i,:)=pwelch(C4(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdCP3(i,:)=pwelch(CP3(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdCP1(i,:)=pwelch(CP1(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdCPz(i,:)=pwelch(CPz(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdCP2(i,:)=pwelch(CP2(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
    psdCP4(i,:)=pwelch(CP4(i,:),hamming(window_len),overlapPercnt,freq_range,samplerate);
   end
   
   
   % normalized PSD
   
   %psdFCz_Norm(i,:) = 10*log10(psdFCz(i,:) ./ abs(psdBaseline));
   
   psdFz_avg=mean(psdFz);psdFC3_avg=mean(psdFC3);psdFC1_avg=mean(psdFC1);psdFCz_avg=mean(psdFCz);
   psdFC2_avg=mean(psdFC2);psdFC4_avg=mean(psdFC4);psdC3_avg=mean(psdC3);psdC1_avg=mean(psdC1);
   psdCz_avg=mean(psdCz);psdC2_avg=mean(psdC2);psdC4_avg=mean(psdC4);psdCP3_avg=mean(psdCP3);
   psdCP1_avg=mean(psdCP1);psdCPz_avg=mean(psdCPz);psdCP2_avg=mean(psdCP2);psdCP4_avg=mean(psdCP4);
   
   psdAVG_allElectrode=[psdFz_avg;psdFC3_avg;psdFC1_avg;psdFCz_avg;psdFC2_avg;...
                        psdFC4_avg;psdC3_avg;psdC1_avg;psdCz_avg;psdC2_avg;psdC4_avg;...
                        psdCP3_avg;psdCP1_avg;psdCPz_avg;psdCP2_avg;psdCP4_avg];
   Feat_psdAll_trial=[psdFz,psdFC3,psdFC1,psdFCz,psdFC2,...
                psdFC4,psdC3,psdC1,psdCz,psdC2,psdC4,...
                psdCP3,psdCP1,psdCPz,psdCP2,psdCP4];
            
%    clear i;
%    figure,
%    for i= 1: size(psdAVG_allElectrode,1)
%    plot(freq,psdAVG_allElectrode(i,:));
%    hold on
%    end
end

