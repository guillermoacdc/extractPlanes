function T = loadCameraHL2Pose(sessionID, frameID)
%LOADCAMERAHL2POSE Summary of this function goes here
%   Detailed explanation goes here
    rootPath=computeMainPaths(sessionID);
    fileName='Depth Long Throw_rig2world.txt';
    pathCamera=fullfile(rootPath,['session' num2str(sessionID)],'raw','HL2',fileName);
    cameraPoses=importdata(pathCamera);
    cameraPoses=cameraPoses(frameID,:);
    T=assemblyTmatrix(cameraPoses(2:13));
    T(1:3,4)=T(1:3,4)*1000;%conversion to mm
end

