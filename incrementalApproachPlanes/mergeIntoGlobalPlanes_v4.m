function [globalPlanes, bufferComposedPlanes] = mergeIntoGlobalPlanes_v4(localPlanes,globalPlanes, tao,...
    theta, lengthBoundsTop, lengthBoundsP, bufferComposedPlanes, tresholdsV, planeModelParameters, gridStep, compensateFactor)
%MERGEINTOGLOBALPLANES_V3 Summary of this function goes here
%   Detailed explanation goes here
if nargin<10
    gridStep=1;
end
addList=[];
fusionList=[];
Nlp=size(localPlanes,2);
Ngp=size(globalPlanes,2);
k1=1;
k2=1;
for i=1:Nlp
    localPlane=localPlanes(i);
    twinFlag=0;
    noTwinCounter=0;
    for j=1:Ngp
        globalPlane=globalPlanes(j);
        typeOfTwin=computeTypeOfTwin_v2(localPlane,globalPlane, tao,...
            theta,lengthBoundsTop, lengthBoundsP, planeModelParameters(1));
        twinFlag=(typeOfTwin~=0);%true for any value of typeOfTwin different than 0
        if twinFlag
            fusionList(k1,:)=[i j typeOfTwin];%index of planes to fuse in order local, global
            k1=k1+1;
        else
            noTwinCounter=noTwinCounter+1;
        end

    end
    if noTwinCounter==Ngp
        addList(k2)=i;%list of local planes that must be added to global planes
        k2=k2+1;
    end
end
% perform additions
if ~isempty(addList)
    for i=1:length(addList)
        globalPlanes=[globalPlanes localPlanes(addList(i))];
    end
end
% perform fusions
if ~isempty(fusionList)
    Nf=size(fusionList,1);
    for i=1:Nf
        localPlaneID=fusionList(i,1);
        globalPlaneID=fusionList(i,2);
        typeOfTwin=fusionList(i,3);
        [globalPlanes, localPlanes, bufferComposedPlanes]=performMerge_v3(localPlanes, localPlaneID,...
                    globalPlanes, globalPlaneID, typeOfTwin, bufferComposedPlanes,...
                    tresholdsV, lengthBoundsTop, lengthBoundsP, planeModelParameters, gridStep, compensateFactor);            
    end
end




end

