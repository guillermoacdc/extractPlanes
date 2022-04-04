function [data] = build2DallignedData_v2(M,N)
%BUILD2DALLIGNEDDATA Summary of this function goes here
%   Detailed explanation goes here
% x=1:spatialSamplingRate:L1;
% y=1:spatialSamplingRate:L2;

% data=ones(length(x)*length(y),2);
k=1;
for(i=1:M)
    for (j=1:N)
        data(k,:)=[i-1 j-1];
        k=k+1;
    end
end

end

