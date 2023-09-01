clc
close all
clear

% 3
sessionsID=[ 	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
Ns=length(sessionsID);
savePath='D:\6DViCuT_p1\misc';
fileName='referencePose_qh.json';
% 1. Plane filtering parameters
th_angle=15*pi/180;%radians
th_size=150;%number of points
th_lenght=10*10;%mm 10 cm - Update with tolerance_length; is in a high value (30) to pass most of the planes
th_occlusion=1.4;%
D_Tolerance=0.1*1000;%mm ... 0.1 m
planeFilteringParameters=[th_lenght, th_size, th_angle, th_occlusion, D_Tolerance];

for i=1:Ns
    sessionID=sessionsID(i);
    [frames, planeID, boxID] = getTargetFramesFromScene(sessionID);
    frameID=frames(1);
    refPlaneDescriptor = computeReferencePoseBySession(sessionID,...
        frameID, planeID, planeFilteringParameters);
    refPose.(['session' num2str(sessionID)])=convertObjectToStruct(refPlaneDescriptor, boxID);
end
folderFlag=false;
mySaveStruct2JSONFile(refPose,fileName,savePath,sessionID,folderFlag)