function time = Time_fromSamples(v, fs) 
%Calculate time in sec
time = 1:length(v);
time = time/fs;