function [globalPlanes] = mergeStrategy(localPlanes,globalPlanes)
%MERGESTRATEGY Summary of this function goes here
%   Detailed explanation goes here

lpCounter=size(localPlanes,2);
gpCounter=size(globalPlanes,2);

i=1;%index to read localPlanes
while lpCounter>=1
    twinFlag=0;
    localPlane=localPlanes(i);

    j=1; %index to read globalPlanes
    while gpCounter>=1 & twinFlag==0
        globalPlane=globalPlanes(j);
        type4 = (globalPlane==localPlane);%isType4
        if type4
            [globalPlanes, localPlanes]=myPerformMerge(globalPlanes,i,localPlanes,j);
            twinFlag=1;
        else
            j=j+1;
            gpCounter=gpCounter-1;
        end
    end

    if ~twinFlag
        globalPlanes=[globalPlanes localPlane];
        i=i+1;
    else
        i=1;
    end
    lpCounter=lpCounter-1;
end

end

