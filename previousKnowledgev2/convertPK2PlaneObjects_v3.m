function planeDescriptor = convertPK2PlaneObjects_v3(rootPath,scene,planeType, frameHL2, boxID)
%CONVERTPK2PLANEOBJECTS_v3 load previous knowledge of an specific scene, then
%converts this knowledge into plane objects and save the result in
%planeDescriptor vector
% _v2: add the input planeType with domain {(0) superior, (1) lateral xz, (2) lateral yz}
%   Detailed explanation goes here
% _v3 adapts the code for subsets of boxes in the session

Nb=length(boxID);
% load inital poses
% initialPoses=loadInitialPose(rootPath,scene,frameHL2);%sorted in pps
initialPoses_obj=loadInitialPose_v3(rootPath,scene,frameHL2,0);%sorted in pps
Nobj=size(initialPoses_obj,2);
initialPoses=zeros(Nobj,13);
for i=1:Nobj
    initialPoses(i,1:end)=unassemblyTMatrix(initialPoses_obj(i));
end
% filter initial poses by boxID
pps=getPPS(rootPath,scene,frameHL2);
indexBoxID=find(pps==boxID);
initialPoses=initialPoses(indexBoxID,:);
% load box lengths
boxLengths = loadLengths_v2(rootPath,pps);%IdBox,Heigth(mm),Width(mm),Depth(mm)
% filter box lengths by boxID
indexBoxLengths=find(boxLengths(:,1)==boxID);
boxLengths =boxLengths(indexBoxLengths,:);

for i=1:Nb
    [L1,L2]=computePlaneLengthsFromGTBox(boxLengths(i,2:4),planeType);
    H=boxLengths(i,2);
    myPlanes(i)=createPlaneObject_v2(initialPoses(i,:),[L1 L2 H], planeType);
    myPlanes(i).idBox=initialPoses(i,1);
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
planeDescriptor.fr0.acceptedPlanes=[zeros(Nb,1) [1:Nb]'];
end

