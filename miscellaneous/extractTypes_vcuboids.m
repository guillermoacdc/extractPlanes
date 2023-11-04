function [xzPlanes, xyPlanes, zyPlanes] = extractTypes_vcuboids(globalPlanes)
%EXTRACTTYPES Extract the type of each plane and returns the groups of 
% indexes xz, xy, zy; 

Np= length(globalPlanes);%
xzPlanes=[];
xyPlanes=[];
zyPlanes=[];

for i=1:Np
    type=globalPlanes(i).type;
    if type
        tilt=globalPlanes(i).planeTilt;
        if ~tilt
            zyPlanes=[zyPlanes; i];
        else
            xyPlanes=[xyPlanes; i];
        end
    else
        xzPlanes=[xzPlanes; i];
    end
end
end