function eADD_m= plot_eADDByFrame(sessionID,frameID,tao,theta,evalPath,...
    dataSetPath,PCpath, NpointsDiagTopSide, planeType, fileName)
%PLOT_EADDBYFRAME Summary of this function goes here
%   Detailed explanation goes here

% read json file
% fileName='estimatedPoses.json';
jsonpath=fullfile(evalPath,['session' num2str(sessionID)], fileName);
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    estimatedPoses = jsondecode(str);
% compute matchID
pps=getPPS(dataSetPath,sessionID,frameID);
matchID=computeMatchID(estimatedPoses.(['frame' num2str(frameID)]),theta,tao,pps);%[estimatedPlaneID boxID]
Ne=size(matchID,1);
Ngt=size(matchID,2);
eADD_m=estimatedPoses.(['frame' num2str(frameID)]).eADD.(['tao' num2str(tao)]);
for i=1:Ne
    eADD_row=eADD_m(i,:);
    planeID=matchID(i,1);
    pathPCScanned=fullfile(PCpath,['corrida' num2str(sessionID)],...
        ['frame' num2str(frameID)], ['Plane' num2str(planeID-1) 'A.ply']);
    boxID=matchID(i,2);
    indexEstimatedPose=find(estimatedPoses.(['frame' num2str(frameID)]).IDObjects==planeID);
    estimatedPose=estimatedPoses.(['frame' num2str(frameID)]).poses(indexEstimatedPose,:);
    plotEstimatedPlaneVsAllGtPlanes(estimatedPose,dataSetPath,...
    sessionID, frameID, boxID, pathPCScanned, NpointsDiagTopSide, planeType, planeID, eADD_row);
end
end

