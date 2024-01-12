function [TPhl2, TPm, FPhl2, FNm] = computeTPFPFNByFrame_vboxDetection(myBoxes,...
            visibleBoxByFrame, gtBoxes, tao, theta, sessionID)
%COMPUTEMETRICSBYFRAME_VBOXDETECTION Computes metrics by frame
%   myBoxes is a vector of box objects. Each element represent a detected
%   box


Ndb=length(myBoxes);

% project position an rotation to qm
dataSetPath=computeReadPaths(sessionID);
Th2m=loadTh2m(dataSetPath,sessionID);
Theight=[0 1 0; 0 0 1; 1 0 0];
for i=1:Ndb
    myBoxes(i).tform=Th2m*myBoxes(i).tform;
    myBoxes(i).tform(1:3,1:3)=myBoxes(i).tform(1:3,1:3)*Theight;
end

% % % validation figures
figure,
myPlotBoxes(gtBoxes , sessionID,'w')
hold on
myPlotBoxes(myBoxes, sessionID, 'y')
hold on
dibujarsistemaref(eye(4),'m',150,2,10,'w');

% compute detection error in matrix form
eD_m=compute_eD_matrix(myBoxes, gtBoxes,tao);
[TPhl2, TPm, FPhl2, matchID]=convert_eDm2TP(eD_m, theta, myBoxes, gtBoxes);

FNm=computeFN_vboxDetection(matchID, visibleBoxByFrame);

end

