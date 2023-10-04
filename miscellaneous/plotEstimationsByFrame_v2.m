function plotEstimationsByFrame_v2(globalPlanes, planeType, sessionID, frameID)
% plots gt and estimated poses in qh

dataSetPath=computeMainPaths(sessionID);
if planeType==0
    % For top planes use
    syntheticPlaneType=0;
%     estimatedPlaneType=0;
else
    % For perpendicular planes use
    syntheticPlaneType=3;
%     estimatedPlaneType=3;
end
%% plot estimations by frame in h-world with gt
% load initial pose
% planeGroup=0;
planeDesc_m=loadInitialPose_v3(dataSetPath,sessionID,frameID,syntheticPlaneType);
% compute Tm2h
Th2m=loadTh2m(dataSetPath,sessionID);
Tm2h=inv(Th2m);
% project poses
planeDesc_h=projectPose(planeDesc_m,Tm2h);
Nb=size(planeDesc_h,2);
% figure,
    myPlotPlanes_v3(globalPlanes,1);
    title(['global planes  in frame ' num2str(frameID)])
    hold on
    for k =1:Nb
        T=planeDesc_h(k).tform;
        ind=planeDesc_h(k).idBox;
        dibujarsistemaref(T,ind,120,2,10,'w');
        hold on
    end
%     axis square
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    grid
