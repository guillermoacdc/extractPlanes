function eADD_m= plot_eADDByFrame(sessionID,frameID,tao,theta,evalPath,...
    dataSetPath,PCpath, NpointsDiagTopSide, planeType, fileName)
%PLOT_EADDBYFRAME Summary of this function goes here
%   Detailed explanation goes here

% read json file
% fileName='estimatedPoses.json';
estimatedPoses = loadEstimationsFile(fileName,sessionID, evalPath);

% jsonpath=fullfile(evalPath,['session' num2str(sessionID)], fileName);
%     fid = fopen(jsonpath); 
%     raw = fread(fid,inf); 
%     str = char(raw'); 
%     fclose(fid); 
%     estimatedPoses = jsondecode(str);
% compute matchID
pps=getPPS(dataSetPath,sessionID,frameID);
matchID=computeMatchID(estimatedPoses.(['frame' num2str(frameID)]),theta,tao,pps);%[estimatedPlaneID boxID]
Ne=size(matchID,1);

eADD_m=estimatedPoses.(['frame' num2str(frameID)]).eADD.(['tao' num2str(tao)]);
for i=1:Ne
    eADD_row=eADD_m(i,:);
    frameID_g=matchID(i,1);%with ia2, will have some values in 0; those 
    % corresponding with composed planes. We dont save those point clouds
    planeID=matchID(i,2);
    if frameID_g==0% we dont have a path for composed planes
        pathPCScanned=[];
    else
        pathPCScanned=fullfile(PCpath,['corrida' num2str(sessionID)],...
        ['frame' num2str(frameID_g)], ['Plane' num2str(planeID-1) 'A.ply']);
    end
    boxID=matchID(i,3);
%     indexEstimatedPose=find(estimatedPoses.(['frame' num2str(frameID)]).IDObjects==planeID);
    indexEstimatedPose=myFind2D([frameID_g planeID],...
        estimatedPoses.(['frame' num2str(frameID)]).IDObjects);
    estimatedPose=estimatedPoses.(['frame' num2str(frameID)]).poses(indexEstimatedPose,:);
    plotEstimatedPlaneVsAllGtPlanes(estimatedPose,dataSetPath,...
    sessionID, frameID, boxID, pathPCScanned, NpointsDiagTopSide,...
    planeType, [frameID_g planeID], eADD_row);
end
end

