function [TPh, TPm, FPh, FNm] = computeTPFPFNByFrame_vplaneTracking(estimatedPlanes,...
            gtVisiblePlanesByFrame, tao, theta, sessionID, NpointsDiagPpal)
%COMPUTEMETRICSBYFRAME_VBOXDETECTION Computes metrics by frame
%   estimatedPlanes is a vector of plane objects. Each element represent a detected
%   box
% gtVisiblePlanesByFrame is a vector of plane objects.
if isempty(estimatedPlanes)
    TPh=[];
    TPm=[];
    FPh=[];
    FNm=[];
else
    % project position an rotation to qm
    estimatedPlanes_m=projectPoses_qh2qm(estimatedPlanes.values,sessionID);
    eADD_m=compute_eADD_v3(estimatedPlanes_m,gtVisiblePlanesByFrame, tao, NpointsDiagPpal);
    eADD_bool=eADD_m>theta;
    gtIDs=extractIDsFromVector(gtVisiblePlanesByFrame);
    estimationsIDs=extractIDsFromVector(estimatedPlanes.values);
    [TPh, TPm, FPh, FNm] = convert_eM2TPFPFN(eADD_bool, gtIDs,estimationsIDs);
end

% % % validation figures
% figure,
%     myPlotPlanes_Anotation(gtVisiblePlanesByFrame,1,'m','y')
%     myPlotPlanes_Anotation(estimatedPlanes_m,1,'m','w')


% figure,
% myPlotBoxes(gtBoxes , sessionID,'w')
% hold on
% myPlotBoxes(estimatedPlanes, sessionID, 'y')
% hold on
% dibujarsistemaref(eye(4),'m',150,2,10,'w');
end

