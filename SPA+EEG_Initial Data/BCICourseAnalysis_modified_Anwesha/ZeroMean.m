function [data_0mean] = ZeroMean(data)
%

mean_electrode=mean(data);

[sampleNum electrodeNum]=size(data);
for i = 1: electrodeNum
    data_0mean(:,i)=data(:,i)- mean_electrode(i);

end
end

