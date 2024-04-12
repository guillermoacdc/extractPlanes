clc
close all
clear 

dataSetPath = computeReadPaths(1);
sessionID=10;
keyFrames=loadKeyFrames(dataSetPath, sessionID);
Nkf=length(keyFrames);
planeType=2;
visiblePlanesFileName='globalVisiblePlanesByFrame.json';
% az=

for i=1:Nkf
    frameID=keyFrames(i);
    if frameID==84
        disp('stop mark')
    end
    gtPlanes=loadGTPlanes_v2(sessionID,frameID,planeType, visiblePlanesFileName);
    disp(frameID)    
    pause(1)
    clf%to clear figure
%     plot gt planes
    myPlotPlanes_Anotation(gtPlanes,0,'m','y')
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    axis vis3d
%     view(3)
end

% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
