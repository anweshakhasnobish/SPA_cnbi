function [ data_CAR ] = CAR( data )
%Common average reference
%   Detailed explanation goes here
meanElectrodes=mean(data,2);

% [sampleNum, electrodeNum]=size(data);
for i = 1: size(data,2)
    data_CAR(:,i)=data(:,i)- meanElectrodes;

end

end

