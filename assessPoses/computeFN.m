function FN = computeFN(eADD_m,gtPoses,...
    sessionID, frameID, theta, planeType)
%COMPUTEFN Computes False Negatives by frame
%   Detailed explanation goes here

% get ID of visible gtPlanes visibleGtPlanesID
fileName='visiblePlanesByFrame.json';
visibleGtPlanesID=loadVisiblePlanesByType(fileName,sessionID, frameID, planeType);

if isempty(eADD_m)
    FN=visibleGtPlanesID;
else
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
    % compute FN as mySetDiff(visibleGtPlanesID,detectedGtPlanesID)
    FN = setDiff_2D(visibleGtPlanesID,detectedGtPlanesID);
end



end

