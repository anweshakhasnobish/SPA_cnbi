function sig_bpf = BPFilter(data,order, low_cutoff, high_cutoff,samplerate)

% band pass filter


[b,a]=ellip(order,1,50,[low_cutoff/(samplerate/2) high_cutoff/(samplerate/2)]); % elliptical filter of order 6 and bandwidth [4 32]Hz

sig_bpf = filter(b,a,data);

