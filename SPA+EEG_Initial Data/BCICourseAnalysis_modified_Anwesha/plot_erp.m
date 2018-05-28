function  plot_erp(erp_data,electrode_labels, samplerate,plot_duration)
%plots the ERPs of the data given by erp_data
%   erp_data= erp_class_1, or erp_class_2, or erp_diff_cls12
%electrode_labels in the array of cells contains the strings of electrode
%labels like 'Fz', 'CP3, etc
%samplerat= EEG.sampleRate
%plot duration is the time in seconds, till which you want to plot the
%erps, maximum 3.5seconds
 clear time;
 time=Time_fromSamples(erp_data(1,:),samplerate);
 time=time(1:find(time==plot_duration));
 
 % Class 1 ERP plots electrode wise
 figure,  
 clear i
 subplot(5,5,3),plot(time,erp_data(1,1:find(time==plot_duration))), axis tight, grid minor, title (electrode_labels{1});
 for i= 2: size(erp_data,1)
 subplot(5,5,(i+4)),plot(time,erp_data(i,1:find(time==plot_duration))), axis tight, grid minor, title (electrode_labels{i});
 end
 

end

