function [filters angles]=createFilterBank(NmbFilters,L1,L2,spatialSamplingRate)
%CREATEFILTERBANK Summary of this function goes here
%   Detailed explanation goes here



% generating data
% data=build2DallignedData(L1,L2, spatialSamplingRate);% whole data
% figure,
% plot(data(:,1),data(:,2),'*')
% title 'raw unstructured data'

% converting data to structured version
M=100*L1+1;
N=100*L2+1;
% M=100*L1;
% N=100*L2;
sdata=180*uint8(ones(round(M),round(N)));
% for i=1:size(sdata,1)
%     sdata(data(i,1)+1,data(i,2)+1)=180;
% end

% figure,
% imshow(sdata)
% title 'raw structured data'
% allocating space for the filter
% Mmax=max(M,N);
% filters=zeros(Mmax,Mmax,NmbFilters);

% filters=uint8(zeros(M,N,NmbFilters));
% computing angles 
angles=linspace(0,180,NmbFilters);
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

