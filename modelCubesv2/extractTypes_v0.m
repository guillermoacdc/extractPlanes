function [xzPlanes, xyPlanes, zyPlanes] = extractTypes(globalPlanes)
%EXTRACTTYPES Extract the type of each plane and returns the groups of 
% indexes xz, xy, zy; 

Np= length(globalPlanes.values);%
xzPlanes=[];
xyPlanes=[];
zyPlanes=[];

for i=1:Np
    type=globalPlanes.values(i).type;
    if type
        tilt=globalPlanes.values(i).planeTilt;
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