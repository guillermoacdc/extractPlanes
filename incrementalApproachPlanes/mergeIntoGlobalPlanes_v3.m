function [globalPlanes, bufferComposedPlanes] = mergeIntoGlobalPlanes_v3(localPlanes,globalPlanes, tao,...
    theta, lengthBoundsTop, lengthBoundsP, bufferComposedPlanes, tresholdsV, planeModelParameters, gridStep)
%MERGEINTOGLOBALPLANES_V3 Summary of this function goes here
%   Detailed explanation goes here
if nargin<10
    gridStep=1;
end
lpCounter=size(localPlanes,2);
gpCounter=size(globalPlanes,2);

i=1;%index to read localPlanes
while lpCounter>=1
    twinFlag=0;
    localPlane=localPlanes(i);

    j=1; %index to read globalPlanes
    while gpCounter>=1 & twinFlag==0
        globalPlane=globalPlanes(j);
%         type4 = (globalPlane==localPlane);%isType4
        typeOfTwin=computeTypeOfTwin_v2(localPlane,globalPlane, tao,...
            theta,lengthBoundsTop, lengthBoundsP, planeModelParameters(1));
        if typeOfTwin~=0
%             [globalPlanes, localPlanes]=myPerformMerge(globalPlanes,i,localPlanes,j);
            [globalPlanes, localPlanes, bufferComposedPlanes]=performMerge_v3(localPlanes, i,...
                globalPlanes, j, typeOfTwin, bufferComposedPlanes,...
                tresholdsV, lengthBoundsTop, lengthBoundsP, planeModelParameters);            
%               [globalPlanes, localPlanes, bufferComposedPlanes]=performMerge_v4(localPlanes, i,...
%                 globalPlanes, j, typeOfTwin, bufferComposedPlanes,...
%                 tresholdsV, lengthBoundsTop, lengthBoundsP,...
%                 planeModelParameters, gridStep);            
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

