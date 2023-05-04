function [vectorPlanes] = mergeSingleFrame(vectorPlanes)
%MERGESINGLEFRAME Summary of this function goes here
%   Detailed explanation goes here

N=size(vectorPlanes,2);
if N==1
    myCounter=0;
else
    nonRPairs=nchoosek(1:N,2);
    myCounter=size(nonRPairs,1);
end

i=1;
while myCounter>=1
    indexA=nonRPairs(i,1);
    indexB=nonRPairs(i,2);
    planeA=vectorPlanes(indexA);
    planeB=vectorPlanes(indexB);
    
    type4= (planeA==planeB);

    if type4
        vectorPlanes=myPerformSingleMerge(vectorPlanes,indexA, indexB);
        N=size(vectorPlanes,2);
        nonRPairs=nchoosek(1:N,2);
        myCounter=size(nonRPairs,1);
        i=1;
    else
        myCounter=myCounter-1;
        i=i+1;
    end

end
end

