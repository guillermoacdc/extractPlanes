function [planeDescriptor] = convertPK2PlaneObjects_v4(dataSetPath,sessionID,...
    planeType, frameHL2, boxID)
%CONVERTPK2PLANEOBJECTS_V4 Solves the problem in v3:
% la función convertPK2PlaneObjects_v3 solo genera un descriptor de plano 
% superior. Si se requieren planos laterales, esta función no entrega la 
% información
planeDescriptor=computePlaneDescriptorsFromBoxID_v2(boxID,sessionID, dataSetPath, planeType);
initPose_m=loadInitialPose(dataSetPath,sessionID,frameHL2);
indexBox=find(initPose_m(:,1)==boxID);
initPose=initPose_m(indexBox,2:end);
% % adjust box height
% initPose=adjustBoxHeight(initPose,boxID,dataSetPath);
Tm2b=assemblyTmatrix(initPose);
planeDescriptor.tform=Tm2b*planeDescriptor.tform;
planeDescriptor.unitNormal=planeDescriptor.tform(1:3,3);
end

