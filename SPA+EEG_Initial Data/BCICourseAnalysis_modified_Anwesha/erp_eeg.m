function [  erp_class_1,  erp_class_2] = erp_eeg(eeg_data, class_1_ind, class_2_ind, samplerate)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
 [dataElectrodes_cls_1, dataElectrodes_cls_2,electrode_labels]=  eegData_electrode_classwise(eeg_data,class_1_ind, class_2_ind);
  
 nb_trialsClass=size(class_1_ind,1);
 %ERP calculation
 clear i j
 j=1;
 for i = 1: (size(dataElectrodes_cls_1,1)/nb_trialsClass)    % no. of channels(electrodes)=16, 
                                                          % nb_trialsClass== no.of trials of a class
      clear temp_cls1 temp_cls2;
      for j= j:(j+nb_trialsClass)-1
         temp_cls1(j,:)=dataElectrodes_cls_1(j,:);
         temp_cls2(j,:)=dataElectrodes_cls_2(j,:);
      end 
     erp_diff_cls12(i,:)=mean(temp_cls1-temp_cls2); % erp of difference between class 1 and 2
     erp_class_1(i,:)=mean(temp_cls1);  %erp class 1, 16 electrode in rows
     erp_class_2(i,:)=mean(temp_cls2);  %erp class 2, 16 electrode in rows
     clear temp_cls1
     j=j+1;
    
 end
 
%  %% ERP features
%  time=Time_fromSamples(erp_class_1(1,:),samplerate);
%  clear i
%  
%  for i=1:size(erp_class_1,1)
%      [maxVal_cls1(i) maxInd_cls1(i)]=max(erp_class_1(i,1:find(time==2)));
%  end
%     maxInd_cls1=maxInd_cls1/samplerate; 
    
  
 %% plot ERPs electrode-wise
plot_duration=2; % in seconds
 % Class 1 ERP plots electrode wise
 plot_erp(erp_class_1,electrode_labels, samplerate,plot_duration);
 suptitle('ERPs Class - 1');
 
 %Class 2 ERP plots
 plot_erp(erp_class_2,electrode_labels, samplerate,plot_duration);
 suptitle('ERPs Class - 2'); 
 
 %Difference : Class 1- Class 2 ERP plots
%   plot_erp(erp_diff_cls12,electrode_labels, samplerate,plot_duration);
%  suptitle('Difference : Class 1- Class 2 ERP plots');
 
end

