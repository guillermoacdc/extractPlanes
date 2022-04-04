function [filters angles]=createFilterBankv2(NmbFilters,M,N,spatialSamplingRate)
%CREATEFILTERBANK Summary of this function goes here
%   Detailed explanation goes here

% generating data
sdata=180*uint8(ones(M,N));

angles=linspace(0,180-(180/NmbFilters),NmbFilters);
% computing values for each member of the filter bank
for i=1:size(angles,2)
    values= uint8(imrotate(sdata,angles(i)));
%     check if flat
    if std(double(values(:)))==0
%         add a framework to the filter
        values(:,1)=0;
        values(:,end)=0;
        values(1,:)=0;
        values(end,:)=0;
    end
    filters{i}=values;
end

end

