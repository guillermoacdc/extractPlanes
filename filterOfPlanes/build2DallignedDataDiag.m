function [data] = build2DallignedDataDiag(L1,L2, spatialSamplingRate)
%BUILD2DALLIGNEDDATA Summary of this function goes here
%   Detailed explanation goes here
x=0:spatialSamplingRate:L1;
y=0:spatialSamplingRate:L2;

% data=ones(length(x)*length(y),2);
k=1;
for(i=1:length(x))
    for (j=1:length(y)-1-i)

            data(k,:)=[i j];
            k=k+1;

    end
end

end

