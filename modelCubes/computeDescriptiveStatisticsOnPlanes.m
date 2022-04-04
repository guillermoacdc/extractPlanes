function [acceptedPlanes, discardedByDorNormal, discardedByLength, topOccludedPlanes]= computeDescriptiveStatisticsOnPlanes(myPlanes)
%COMPUTEDESCRIPTIVESTATISTICSONPLANES Summary of this function goes here
%   Detailed explanation goes here
acceptedPlanes=[];
discardedByDorNormal=[];
discardedByLength=[];
topOccludedPlanes=[];
k1=1;
k2=1;
k3=1;
k4=1;
k5=1;
for i=1:length(myPlanes)

    if(myPlanes{i}.type==2 | myPlanes{i}.DFlag==1)
        discardedByDorNormal(k1)=i;
        k1=k1+1;
%         continue;
    end
    
    if (myPlanes{i}.lengthFlag==1)
        discardedByLength(k2)=i;
        k2=k2+1;
    end

    if (myPlanes{i}.lengthFlag==0 & ( isempty(myPlanes{i}.DFlag) | myPlanes{i}.DFlag==0) )
        acceptedPlanes(k3)=i;
        k3=k3+1;
    end
    
    if (myPlanes{i}.antiparallelFlag==1)
        antiparallelPlanes(k4)=i;
        k4=k4+1;
    end

	if (myPlanes{i}.topOccludedPlaneFlag==1)
        topOccludedPlanes(k5)=i;
        k5=k5+1;
    end

end

end

