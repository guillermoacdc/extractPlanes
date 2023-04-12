function  mypcshow(planeDescriptor,dataSetPath,sessionID)
%MYPCSHOW reads a pc, convert to mm, project to qm and shows
%   Detailed explanation goes here

pc=myPCread(planeDescriptor.pathPoints);%mm
Th2m=loadTh2m(dataSetPath,sessionID);
pc_p=myProjection_v3(pc,Th2m);
pcshow(pc_p);
end

