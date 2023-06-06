function trendDetections =computeTrendDetections(matchM, pps)
%COMPUTETRENDDETECTIONS Computes the vector trendDetections wit size Npps,3: 
% The column 1 has a detection flag: (0) for nondetected box in the frame, 
% (1) for a detected box
% The columns 2 and 3 contain the 2D ID of the detected plane. 

% Assumptions: 
% The detected plane ID has two dimensions
% The ground truth object has a single dimension ID (top planes)

% compute default outuput
Npps=size(pps,1);
trendDetections=zeros(Npps,3);

IDDetectedObject=matchM(:,3);
IDzeroValues=find(IDDetectedObject==0);
IDDetectedObject(IDzeroValues)=[];
Ndo=size(IDDetectedObject,1);

if Ndo>0
    for i=1:Ndo
        indexPPS=find(pps==IDDetectedObject(i));
        trendDetections(indexPPS,:)=[1 matchM(i,1:2)];
    end
else
end


end

