function [TPhl2, TPm, FPhl2, FNm] = computeDetectedBoxes_TPFPFNByFrame(myBoxes,...
            visibleBoxByFrame, gtBoxes, tao_size, tao_translation, th_d, sessionID)
%COMPUTEDETECTEDBOXES_TPFPFNBYFRAME Computes metrics by frame
%   myBoxes is a vector of box objects. Each element represent a detected
%   box
%   Detailed explanation goes here
Ndb=length(myBoxes);
% project position an rotation to qm
dataSetPath=computeReadPaths(sessionID);
Th2m=loadTh2m(dataSetPath,sessionID);
Theight=[0 1 0; 0 0 1; 1 0 0];
for i=1:Ndb
    myBoxes(i).tform=Th2m*myBoxes(i).tform;
    myBoxes(i).tform(1:3,1:3)=myBoxes(i).tform(1:3,1:3)*Theight;
end

% % validation figures
% figure,
% myPlotBoxes(gtBoxes , sessionID,'w')
% hold on
% myPlotBoxes(myBoxes, sessionID, 'y')
% hold on
% dibujarsistemaref(eye(4),'m',150,2,10,'w');

% compute detection error in matrix form
eD_m=computeDetectionErrorMatrix(myBoxes, gtBoxes,tao_size, tao_translation);
myBoxesIDs = extractIDsFromBoxVector(myBoxes);
gtBoxesIDs=extractIDsFromBoxVector(gtBoxes);
[TPhl2, TPm, FPhl2, FNm]=errorMatrix2TPFPFN_vdetection(eD_m,...
    th_d, gtBoxesIDs, myBoxesIDs);

end

