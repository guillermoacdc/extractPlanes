function planeDescriptors = project2qm(planeDescriptors,sessionID)
%PROJECT2QM Projects a plane object from qh to qm
%   Detailed explanation goes here
% project position an rotation to qm
N=length(planeDescriptors);
dataSetPath=computeReadPaths(sessionID);
Th2m=loadTh2m(dataSetPath,sessionID);
% Theight=[0 1 0; 0 0 1; 1 0 0];
% Theight=rotx(-90);
for i=1:N
%     project tform
    planeDescriptors(i).tform=Th2m*planeDescriptors(i).tform;
% project geometric center
    newgc=Th2m*[planeDescriptors(i).geometricCenter; 1];
    planeDescriptors(i).geometricCenter=newgc(1:3);
% adjust frames
%     planeDescriptors(i).tform(1:3,1:3)=planeDescriptors(i).tform(1:3,1:3)*Theight;
end
end

