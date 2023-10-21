function [planeDescriptors] = loadInitialPose_v3(dataSetPath,sessionID,frame,planesGroup)
%LOADINITIALPOSE of boxes in the sequence boxID, r11, r12, r133,, px... pz
%   Detailed explanation goes here
% dataSetPath, - as dataSetPath
% sessionID, - as sessionID number
% frame, - as hololens frame where the initial pose is required. Note that
% the pose is function of the hololens frame. Some sessionIDs have a first pose 
% at begining and a second pose (reposition) after a reference frame.
% Warning. The poses must be returned in the sequence of pps (physical packing seq)
% planesGroup:{0 1 2}
% 0: top planes
% 1: back and front planes
% 2: lateral planes (left and right) 
% v3: return a vector of plane descriptors instead a pose

pps=getPPS(dataSetPath, sessionID, frame);
Nb=size(pps,1);
switch planesGroup
    case 0
        planeTypes=1;%top
    case 1
        planeTypes=[2 4];%front and back
    case 2
        planeTypes=[3 5];%right and left
    case 3
        planeTypes=[2 3 4 5];%front, right, back and left
    case 4
        planeTypes=1:5;%all planes
end
Npt=size(planeTypes,2);
initialPoses=zeros(Npt*Nb,13);
k=1;
for i=1:Nb
    boxID=pps(i);
    for j=1:Npt
        planeType=planeTypes(j);
        planeDescriptors(k)=convertPK2PlaneObjects_v4(dataSetPath,sessionID,planeType,frame,boxID);
%         initialPoses(k,:)=unassemblyTMatrix(planeDescriptor);
        k=k+1;
    end
end

end

