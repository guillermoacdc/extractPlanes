function [xzPlanes,  xyzyPlanes] = extractTypes_woutPK(myPlanes, planeIndex, th_angle)
%EXTRACTTYPES Extract the type of each plane and returns the groups xz, xy,
%zy; the type is codified in two properties: plane.type, plane.planeTilt
%   Detailed explanation goes here

xzPlanes=[];
xyzyPlanes=[];

N=size(planeIndex,1);
for i=1:N
    frame=planeIndex(i,1);
    element=planeIndex(i,2);
    myNormal=myPlanes.(['fr' num2str(frame)]).values(element).unitNormal;
    alpha=computeAngleBtwnVectors(myNormal, [0 1 0]);


    if( abs(cos(alpha*pi/180)) > cos (th_angle))%con abs también va a aceptar antiparalelos
        myPlanes.(['fr' num2str(frame)]).values(element).type=0;
        xzPlanes=[xzPlanes; planeIndex(i,:)];
    else
        myPlanes.(['fr' num2str(frame)]).values(element).type=1;
        xyzyPlanes=[xyzyPlanes; planeIndex(i,:)];
    end
    
end
end

