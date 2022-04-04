function [sdataOccludedR ]= createOccludedPlaneSample(L1,L2,L1p,L2p, myangle, spatialSamplingRate)
%CREATEOCCLUDEDPLANESAMPLE Summary of this function goes here
%   Detailed explanation goes here
M=100*L1+1;
N=100*L2+1;
% crear datos 2D alineados con ejes x y
data=build2DallignedData(L1,L2, spatialSamplingRate);% whole data
% crear versión ocluida
data2=build2DallignedData(L1p*L1,L2p*L2, spatialSamplingRate);%
% data2=data2+[4 10];
[datax index]=setdiff(data,data2,'rows');
dataOccludedA=data(index,:);

sdataOccludedA=uint8(zeros(round(M),round(N)));
for i=1:size(dataOccludedA,1)
    sdataOccludedA(dataOccludedA(i,1)+1,dataOccludedA(i,2)+1)=180;
end
sdataOccludedR = imrotate(sdataOccludedA,myangle);
% figure,
% plot(dataOccludedA(:,1),dataOccludedA(:,2),'*','color', [.5 .5 .5])%gray color in vector 
% title 'unstructured data'
% figure,
% imshow(sdataOccludedA)
% title 'structured data'
end

