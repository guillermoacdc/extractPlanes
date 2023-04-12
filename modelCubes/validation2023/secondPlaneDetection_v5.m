function [secondPlaneIndex detectionFlag] = secondPlaneDetection_v5(targetPlane,...
    searchSpaceT,planesDescriptor, th_angle )
%SECONPLANEDETECTION Summary of this function goes here
%   computes second plane based on section 4.1 in [1]
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf
% 
% _v2 is the identifier for the two dimensional version in the index of the
% planes. each index has the form [v1 v2], where v1 is the frame id and v2
% is the plane id
% _v5 uses the structure planesDescriptor with the fields (1) camerapose, (2) values

%% initialize vars
% candidates vectors
c_perpendicularity=[];
c_convexity=[];
%other vars
k=1;
frame_tp=targetPlane(1,1);
element_tp=targetPlane(1,2);
secondPlaneIndex=[0 0];
detectionFlag=0;
%% add previously secondPlane to the search space if exists
if ~isempty(planesDescriptor.(['fr' num2str(frame_tp)]).values(element_tp).secondPlaneID)
    searchSpaceT=[searchSpaceT; planesDescriptor.(['fr' num2str(frame_tp)]).values(element_tp).secondPlaneID];
    searchSpaceT=unique(searchSpaceT,'rows','stable');%avoid duplicates
end

% select candidates by perpendicularity criterion
c_perpendicularity = searchCandidates_perp_v2(frame_tp, element_tp, searchSpaceT, planesDescriptor, th_angle);
if ~isempty(c_perpendicularity)
    % select candidates by convexity criterion
    c_convexity=searchCandidates_conv_v2(c_perpendicularity, frame_tp, element_tp, planesDescriptor);
    if ~isempty(c_convexity)
        % select candidates by distance criterion
        v1=planesDescriptor.(['fr' num2str(frame_tp)]).values(element_tp).geometricCenter;
        for i=1:1:size(c_convexity,1)
            frame_ss=c_convexity(i,1);
            element_ss=c_convexity(i,2);
            v2=planesDescriptor.(['fr' num2str(frame_ss)]).values(element_ss).geometricCenter;
            dist_v(i)=norm(v1-v2);
        end
        [~,selectedIndex]=min(dist_v);
        secondPlaneIndex(1,1)=c_convexity(selectedIndex,1);
        secondPlaneIndex(1,2)=c_convexity(selectedIndex,2);
        detectionFlag=1;
    end
end

end


