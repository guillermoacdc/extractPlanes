function myBox = projectBox2qm(myBox,sessionID)
%PROJECT2QM Projects a box object from qh to qm
%   Detailed explanation goes here
% project position an rotation to qm

dataSetPath=computeReadPaths(sessionID);
Th2m=loadTh2m(dataSetPath,sessionID);
Theight=[0 1 0; 0 0 1; 1 0 0];
% Theight=rotx(-90);
%     project tform
    myBox.tform=Th2m*myBox.tform;

% adjust frames
    myBox.tform(1:3,1:3)=myBox.tform(1:3,1:3)*Theight;
end

