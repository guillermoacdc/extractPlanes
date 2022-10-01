function planeDescriptor = convertPK2PlaneObjects(rootPath,scene)
%CONVERTPK2PLANEOBJECTS load previous knowledge of an specific scene, then
%converts this knowledge into plane objects and save the result in
%planeDescriptor vector
%   Detailed explanation goes here
initialPoses=loadInitialPose_v2(rootPath,scene);
boxLengths = loadLengths(rootPath,scene);
% discard height
% boxLengths = boxLengths(:,[1:2]);
N=size(boxLengths,1);

for i=1:N
    length=boxLengths(i,[2 3]);
    myPlanes(i)=createPlaneObject(initialPoses(i,:),length);
    myPlanes(i).idBox=initialPoses(i,1);
    myPlanes(i).idFrame=0;
    myPlanes(i).idPlane=i;
    myPlanes(i).idScene=scene;
end
planeDescriptor.fr0.values=myPlanes;
planeDescriptor.fr0.acceptedPlanes=[zeros(N,1) [1:N]'];
end

