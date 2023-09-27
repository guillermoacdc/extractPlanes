function FN = computeFN(eADD_m,gtPoses,...
    sessionID, frameID, theta, planeType)
%COMPUTEFN Computes False Negatives by frame
%   Detailed explanation goes here
% theta=0.5;
% planeType=1;
% get ID of detected gtPlanes detectedGtPlanesID; requires a theta
detectedGtPlanesID=[];
Ncols=size(eADD_m,2);
eADD_bool=eADD_m<theta;
for i=1:Ncols
    indexDetection=find(eADD_bool(:,i));
    if ~isempty(indexDetection)
        planeID=[gtPoses(i).idBox gtPoses(i).idPlane];
        detectedGtPlanesID=[detectedGtPlanesID; planeID];
    end
end

% get ID of visible gtPlanes visibleGtPlanesID
fileName='visiblePlanesByFrame.json';
visibleGtPlanesID=loadVisiblePlanesByType(fileName,sessionID, frameID, planeType);
% compute FN as mySetDiff(visibleGtPlanesID,detectedGtPlanesID)
FN = setDiff_2D(visibleGtPlanesID,detectedGtPlanesID);
% if ~isempty(FN)
%     display('FN different than zero')
% end

end

