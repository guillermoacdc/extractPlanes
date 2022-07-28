function [xzPlanes xyPlanes zyPlanes] = extractTypes(myPlanes, planeIndex)
%EXTRACTTYPES Extract the type of each plane and returns the groups xz, xy,
%zy; the type is codified in two properties: plane.type, plane.planeTilt
%   Detailed explanation goes here

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
    type=myPlanes.(['fr' num2str(frame)]).values(element).type;
    if type
        tilt=myPlanes.(['fr' num2str(frame)]).values(element).planeTilt;
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

