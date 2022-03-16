function [acceptedPlanes, discardedByNormal, discardedByLength]= computeDescriptiveStatisticsOnPlanes(myPlanes)
%COMPUTEDESCRIPTIVESTATISTICSONPLANES Summary of this function goes here
%   Detailed explanation goes here
acceptedPlanes=[];
discardedByNormal=[];
discardedByLength=[];
k1=1;
k2=1;
k3=1;
k4=1;
for i=1:length(myPlanes)
    if(myPlanes{i}.type==2)
        discardedByNormal(k1)=i;
        k1=k1+1;
    end
    
    if (myPlanes{i}.lengthFlag==0)
        discardedByLength(k2)=i;
        k2=k2+1;
    end
    
    if (myPlanes{i}.lengthFlag==1)
        acceptedPlanes(k3)=i;
        k3=k3+1;
    end

	if (myPlanes{i}.antiparallelFlag==1)
        antiparallelPlanes(k4)=i;
        k4=k4+1;
    end
end

end

