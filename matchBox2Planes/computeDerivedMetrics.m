function [derivedMetrics] = computeDerivedMetrics(counterDetections)
%COMPUTEDERIVEDMETRICS Summary of this function goes here
%   Detailed explanation goes here
% counterDetections=[pps detectedPlanesByFrame]
N=size(counterDetections,1);
derivedMetrics=zeros(N,4);%[pps, detectedPlanesByFrame(DP), multiple times detected planes by frame (MD), missing planes (MP) ]
derivedMetrics(:,1:2)=counterDetections;

for i=1:N
    DP=derivedMetrics(i,2);
%     multiple times detected planes (MD)
    if DP>=2
        derivedMetrics(i,3)=DP-1;%
    else
        derivedMetrics(i,3)=0;%
    end
%     missing planes (MP)
    if DP==0
        derivedMetrics(i,4)=1;%
    else
        derivedMetrics(i,4)=0;%
    end
end


end

