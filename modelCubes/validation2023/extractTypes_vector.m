    function [xzPlanes, xyPlanes, zyPlanes] = extractTypes_vector(myPlanes, planeIndex)
%EXTRACTTYPES Extract the type of each plane and returns the groups xz, xy,
%zy; the type is codified in two properties: plane.type, plane.planeTilt
%   Detailed explanation goes here
% _vector: process a vector instead a structure
if nargin==1
    planeIndex=computeAcceptedPlanesIds(myPlanes);%
end


xzPlanes=[];
xyPlanes=[];
zyPlanes=[];

N=size(planeIndex,1);
for i=1:N

    frame=planeIndex(i,1);
    element=planeIndex(i,2);
    type=myPlanes(i).type;
    if type
        tilt=myPlanes(i).planeTilt;
        if ~tilt
            zyPlanes=[zyPlanes; planeIndex(i,:)];
        else
            xyPlanes=[xyPlanes; planeIndex(i,:)];
        end
    else
        xzPlanes=[xzPlanes; planeIndex(i,:)];
    end

end
end

