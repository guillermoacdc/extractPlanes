function [secondPlaneIndex, detectionFlag] = secondPlaneDetection_v5(targetIndex,...
    searchSpaceT,globalPlanes, th_angle )
%SECONPLANEDETECTION Summary of this function goes here
%   computes second plane based on section 4.1 in [1]
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf
% 
% _v2 is the identifier for the two dimensional version in the index of the
% planes. each index has the form [gc_target v2], where gc_target is the frame id and v2
% is the plane id
% _v5 uses the structure globalPlanes with the fields (1) camerapose, (2) values

%Distance treshold to filter couples of planes. Update using an inpunt argument
% currently we use dx/2 where dx is the hypotenuse of the greater box (box30)
th_distance=510;

%% initialize vars
% candidates vectors
c_perpendicularity=[];
c_convexity=[];
%other vars
% k=1;
% frame_tp=targetIndex(1,1);
% element_tp=targetIndex(1,2);
secondPlaneIndex=[];
detectionFlag=false;
%% add previously secondPlane to the search space if exists
% if ~isempty(globalPlanes.(['fr' num2str(frame_tp)]).values(element_tp).secondPlaneID)
%     searchSpaceT=[searchSpaceT; globalPlanes.(['fr' num2str(frame_tp)]).values(element_tp).secondPlaneID];
%     searchSpaceT=unique(searchSpaceT,'rows','stable');%avoid duplicates
% end

% select candidates by perpendicularity criterion
c_perpendicularity = searchCandidates_perp_v2(searchSpaceT, targetIndex,  globalPlanes, th_angle);
if ~isempty(c_perpendicularity)
    % select candidates by convexity criterion
    c_convexity=searchCandidates_conv_v2(c_perpendicularity, targetIndex, globalPlanes);
    if ~isempty(c_convexity)

        c_gcRelations=searchCandidates_geometriCenterRelationships(c_convexity,targetIndex,globalPlanes);
        if ~isempty(c_gcRelations)
            % select candidates by distance criterion
            gc_target=globalPlanes(targetIndex).geometricCenter;
            for i=1:1:length(c_gcRelations)
                element_ss=c_gcRelations(i);
                v2=globalPlanes(element_ss).geometricCenter;
                dist_v(i)=norm(gc_target-v2);
            end
%             condition this selection to a threshold in the min distance
            distMin=min(dist_v);
            if distMin<th_distance
%                 disp('the distance btwn couples from secondPlaneDetection is ')
%                 disp(distMin)
                [~,selectedIndex]=min(dist_v);
                secondPlaneIndex=c_gcRelations(selectedIndex);
                detectionFlag=1;
            end
        end
    end
end

end


