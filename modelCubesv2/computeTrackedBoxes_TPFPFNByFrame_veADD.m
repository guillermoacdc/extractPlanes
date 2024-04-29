function [TPhl2, TPm, FPhl2, FNm] = computeTrackedBoxes_TPFPFNByFrame_veADD(myBoxes,...
            currentBoxByFrame, gtBoxes, tao, th_ADD, sessionID, Npointsdp)
%COMPUTEDETECTEDBOXES_TPFPFNBYFRAME Computes metrics by frame
%   myBoxes is a vector of box objects. Each element represent a detected
%   box
% currentBoxByFrame. boxes id that satisfies two conditions: (1) they are
% present in consolidation zone at current frame , (2) they are visible from
% mobile camera in current frame or previous frames
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
gtCurrentBoxes=extractBoxesVector(gtBoxes,currentBoxByFrame);

% eD_m=computeDetectionErrorMatrix(myBoxes, gtBoxes,tao_size, tao_translation);
% eRotationMatrix=computeRotationErrorMatrix(myBoxes, gtCurrentBoxes);
eTracking_m=computeTrackingErrorMatrix_veADD(myBoxes, gtCurrentBoxes,tao,Npointsdp);
% (myBoxes,...
%     gtBoxes,tao, Npointsdp)
myBoxesIDs = extractIDsFromBoxVector(myBoxes);
% gtBoxesIDs=extractIDsFromBoxVector(gtBoxes);
gtCurrentBoxesIDs=extractIDsFromBoxVector(gtCurrentBoxes);

[TPhl2, TPm, FPhl2, FNm]=errorMatrix2TPFPFN_vdetection(eTracking_m,...
    th_ADD, gtCurrentBoxesIDs, myBoxesIDs);

end

