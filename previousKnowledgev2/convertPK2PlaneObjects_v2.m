function [planeDescriptor, pps] = convertPK2PlaneObjects_v2(rootPath,scene,planeType, frameHL2)
%CONVERTPK2PLANEOBJECTS load previous knowledge of an specific scene, then
%converts this knowledge into plane objects and save the result in
%planeDescriptor vector
% _v2: add the input planeType with domain {(0) superior, (1) lateral xz, (2) lateral yz}
%   Detailed explanation goes here

% initialPoses=loadInitialPose_v2(rootPath,scene,repositionFlag);
initialPoses=loadInitialPose(rootPath,scene,frameHL2);
pps=initialPoses(:,1);%physical packing sequence---load from function
% pps=getPPS(rootPath,scene);
% boxLengths = loadLengths_v2(rootPath,scene,pps);%IdBox,Heigth(mm),Width(mm),Depth(mm)
boxLengths = loadLengths_v2(rootPath,pps);%IdBox,Heigth(mm),Width(mm),Depth(mm)
N=size(boxLengths,1);

for i=1:N
    [L1,L2]=computePlaneLengthsFromGTBox(boxLengths(i,2:4),planeType);
    H=boxLengths(i,2);
    myPlanes(i)=createPlaneObject_v2(initialPoses(i,:),[L1 L2 H], planeType);
    myPlanes(i).idBox=initialPoses(i,1);
    if myPlanes(i).idBox==29
        disp('stop from debugger')
    end
    myPlanes(i).idFrame=0;
    myPlanes(i).idPlane=i;
    myPlanes(i).idScene=scene;
    if L2==boxLengths(i,2)
        myPlanes(i).L2toY=true;
    else
        myPlanes(i).L2toY=false;
    end
end

planeDescriptor.fr0.values=myPlanes;
planeDescriptor.fr0.acceptedPlanes=[zeros(N,1) [1:N]'];
end

