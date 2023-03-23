function plotGTPlanesvsEstimated(sessionID, frameID, tao, theta, ...
    spatialSampling, evalPath, dataSetPath)
% plotGTPlanesvsEstimated. plots pairs of segment of planes: (1) estimated
% and (2) ground truth. Includes information of coordinate reference,
% eADD_pc error

fileName=['estimatedPoseA_session' num2str(sessionID) '_tao' num2str(tao)...
    '_theta' num2str(theta) '.csv'];
T=readtable([evalPath 'scene' num2str(sessionID) '\' fileName]);
% frameArray=table2array(T.frameID);
indexes=find(T.frameID==frameID);
Ndp=length(indexes);%number of correct detected poses
planesDescriptor_gt = convertPK2PlaneObjects_v2(dataSetPath,sessionID,0,frameID);

pps=getPPS(dataSetPath,sessionID,frameID);
for i=1:Ndp
    index=indexes(i);
    boxID=table2array(T(index,"boxID"));
    ppsindex=find(pps==boxID);
    planeDescriptor_gt=planesDescriptor_gt.fr0.values(ppsindex);%must follow the pps index
%     extracts plane descriptor associated with boxID
    plotPairsOfPlanes(T(index,:), planeDescriptor_gt, spatialSampling, boxID,dataSetPath)
end

end
