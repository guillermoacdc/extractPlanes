clc
close all
clear all


rootPath="C:\lib\boxTrackinPCs\";
scene=5;
boxID=15;

keyframes=loadKeyFrames(rootPath,scene);
planesDescriptors_gt=convertPK2PlaneObjects(rootPath,scene);
plane_gt=extractPlaneByBoxID(planesDescriptors_gt,boxID);

N=size(keyframes,2);

out=zeros(N,3);
for i=1:5
    frame=keyframes(i);
    planesEstimated=detectPlanes(rootPath,scene,frame);
    topPlanesEstimated=extractTypes(planesEstimated,planesEstimated.(['fr' num2str(frame)]).acceptedPlanes); 
    [planeID,flag] = match(topPlanesEstimated,planesEstimated,plane_gt,scene,rootPath);
    out(i,:)=[boxID planeID flag];
end