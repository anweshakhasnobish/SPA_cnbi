function plot_psd(psd_data_electrode, freq_range)
%UNTITLED2 psd_data_electrode, has the psds of the elctrodes row-wise
%   Detailed explanation goes here
   clear i;
   figure,
   for i= 1: size(psd_data_electrode,1)
   plot(freq_range,psd_data_electrode(i,:));
   hold on
   end

end

