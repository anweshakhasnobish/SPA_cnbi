function [dataElectrodes_cls_1, dataElectrodes_cls_2,electrode_labels]...
                                            =  eegData_electrode_classwise(eeg_data,class_1_ind, class_2_ind)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[Fz,FC3,FC1,FCz,FC2,FC4,C3,C1,Cz,C2,C4,CP3,CP1,CPz,CP2,CP4,electrode_labels] = eegData_electrode(eeg_data);


clear i
 
 for i = 1: size(class_1_ind)
     Fz_class_1(i,:)=Fz(class_1_ind(i),:);Fz_class_2(i,:)=Fz(class_2_ind(i),:);
     FC3_class_1(i,:)= FC3(class_1_ind(i),:);FC3_class_2(i,:)= FC3(class_2_ind(i),:);
     FC1_class_1(i,:)=FC1(class_1_ind(i),:);FC1_class_2(i,:)=FC1(class_2_ind(i),:);
     FCz_class_1(i,:)=FCz(class_1_ind(i),:);FCz_class_2(i,:)=FCz(class_2_ind(i),:);
     FC2_class_1(i,:)=FC2(class_1_ind(i),:);FC2_class_2(i,:)=FC2(class_2_ind(i),:);
     FC4_class_1(i,:)=FC4(class_1_ind(i),:);FC4_class_2(i,:)=FC4(class_2_ind(i),:);
     C3_class_1(i,:)=C3(class_1_ind(i),:);C3_class_2(i,:)=C3(class_2_ind(i),:);
     C1_class_1(i,:)=C1(class_1_ind(i),:);C1_class_2(i,:)=C1(class_2_ind(i),:);
     Cz_class_1(i,:)=Cz(class_1_ind(i),:);Cz_class_2(i,:)=Cz(class_2_ind(i),:);
     C2_class_1(i,:)=C2(class_1_ind(i),:);C2_class_2(i,:)=C2(class_2_ind(i),:);
     C4_class_1(i,:)=C4(class_1_ind(i),:);C4_class_2(i,:)=C4(class_2_ind(i),:);
     CP3_class_1(i,:)=CP3(class_1_ind(i),:);CP3_class_2(i,:)=CP3(class_2_ind(i),:);
     CP1_class_1(i,:)=CP1(class_1_ind(i),:);CP1_class_2(i,:)=CP1(class_2_ind(i),:);
     CPz_class_1(i,:)=CPz(class_1_ind(i),:);CPz_class_2(i,:)=CPz(class_2_ind(i),:);
     CP2_class_1(i,:)=CP2(class_1_ind(i),:);CP2_class_2(i,:)=CP2(class_2_ind(i),:);
     CP4_class_1(i,:)= CP4(class_1_ind(i),:); CP4_class_2(i,:)= CP4(class_2_ind(i),:);
 end

 dataElectrodes_cls_1=[Fz_class_1;FC3_class_1;FC1_class_1;FCz_class_1;FC2_class_1;FC4_class_1;...
                       C3_class_1;C1_class_1;Cz_class_1;C2_class_1;C4_class_1;CP3_class_1;...
                       CP1_class_1;CPz_class_1;CP2_class_1;CP4_class_1];    
                    % the class wise matrix, [no. of trials x (no.of samples in 1 trial(i.e. duration*fs)* no. of electrodes) ]
          
 dataElectrodes_cls_2=[Fz_class_2;FC3_class_2;FC1_class_2;FCz_class_2;FC2_class_2;FC4_class_2;...
                       C3_class_2;C1_class_2;Cz_class_2;C2_class_2;C4_class_2;CP3_class_2;...
                       CP1_class_2;CPz_class_2;CP2_class_2;CP4_class_2];
 
end

