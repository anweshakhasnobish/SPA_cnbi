function [Fz,FC3,FC1,FCz,FC2,FC4,C3,C1,Cz,C2,C4,CP3,CP1,CPz,CP2,CP4, electrode_labels] = eegData_electrode(eeg_data)
% extracts the eeg data of corresponding channenls
%   Detailed explanation goes here

electrode_labels{1}='Fz';electrode_labels{2}='FC3';electrode_labels{3}='FC1';electrode_labels{4}='FCz';
electrode_labels{5}='FC2'; electrode_labels{6}='FC4'; electrode_labels{7}='C3';electrode_labels{8}='C1';
electrode_labels{9}='Cz';electrode_labels{10}='C2'; electrode_labels{11}='C4';electrode_labels{12}='CP3';
electrode_labels{13}='CP1'; electrode_labels{14}='CPz'; electrode_labels{15}='CP2'; electrode_labels{16}='CP4';

Fz= eeg_data(:,:,1); FC3= eeg_data(:,:,2);FC1= eeg_data(:,:,3);FCz= eeg_data(:,:,4);
FC2= eeg_data(:,:,5);FC4= eeg_data(:,:,6);C3= eeg_data(:,:,7);C1= eeg_data(:,:,8);
Cz= eeg_data(:,:,9);C2= eeg_data(:,:,10);C4= eeg_data(:,:,11);CP3= eeg_data(:,:,12);
CP1= eeg_data(:,:,13);CPz= eeg_data(:,:,14);CP2= eeg_data(:,:,15);CP4= eeg_data(:,:,16);

% [trialNum sampleNum electrodeNum]=size(eeg_data);
% varName_elctrd='elctrd';
% clear i index_i
% for i=1:trialNum
%      index_i{i}=num2str(i);
%      var_index=strcat(varName_elctrd,index_i{i});
%      var_index_struct{i}=var_index;
%      data_elctrd= eeg_data(:,:,i);
%     eval([var_index_struct{i} '=data_elctrd']);
%     clear data_electrd 

    

end


