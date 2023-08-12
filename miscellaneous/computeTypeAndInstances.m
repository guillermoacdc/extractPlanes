function [numInstances] = computeTypeAndInstances(sessionID,frameID)
%COMPUTETYPEANDINSTANCES returns a vector of ten elements. The index of the
%vector represents the box's type. The value at index represents the number
% of instances
% called by computeHeterogenetyLevel.m

dataSetPath=computeMainPaths(sessionID);
pps=getPPS(dataSetPath, sessionID, frameID);
Npps=size(pps,1);
numInstances=zeros(1,10);%the dataset have 10 box types
for i=1:Npps
%     computeType
    if pps(i)<=4 & pps(i)>=1
        type=1;
    end
    if pps(i)<=8 & pps(i)>=5
        type=2;
    end    
    if pps(i)<=12 & pps(i)>=9
            type=3;
    end
    if pps(i)<=16 & pps(i)>=13
            type=4;
    end
    if pps(i)<=20 & pps(i)>=17
            type=5;
    end
    if pps(i)==21 
            type=6;
    end
    if pps(i)<=24 & pps(i)>=22
            type=7;
    end
    if pps(i)<=28 & pps(i)>=25
            type=8;
    end
    if pps(i)==29
            type=9;
    end
    if pps(i)==30
            type=10;
    end
% update number of instances
numInstances(type)=numInstances(type)+1;
end

end

