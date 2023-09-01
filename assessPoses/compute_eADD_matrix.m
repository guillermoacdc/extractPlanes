function [eADD_m] = compute_eADD_matrix(sessionID, tao, NpointsDiagPpal,...
    fileName_estimations, planesGroup)
%COMPUTE_EADD_MATRIX Summary of this function goes here
%   Detailed explanation goes here

[dataSetPath,evalPath,~]=computeMainPaths(sessionID);
keyFrames=loadKeyFrames(dataSetPath,sessionID);
Nkf=size(keyFrames,2);

estimatedPoses_h = loadEstimationsFile(fileName_estimations,sessionID, evalPath);

for i =1:Nkf
    if (i==21)
        disp('stop mark')
    end
    frameID=keyFrames(i);
    disp(['Assessing planes in frame' num2str(frameID) '; i=' num2str(i) '/' num2str(Nkf)])
    gtPose_rel=loadInitialPose_relative(sessionID,frameID,planesGroup);
    if isempty(estimatedPoses_h.(['frame' num2str(frameID)]))
        Nb=size(gtPose_rel,2);
        eADD_m.(['frame' num2str(frameID)]).(['tao' num2str(tao)])=zeros(1,Nb);
    else
        estimatedPose_rel=projectDescriptorToRelativePose(estimatedPoses_h.(['frame' num2str(frameID)]),sessionID, frameID);
        eADD_m.(['frame' num2str(frameID)]).(['tao' num2str(tao)])=compute_eADD_v3(estimatedPose_rel,gtPose_rel,tao,NpointsDiagPpal);
    end
    
    
end

end

