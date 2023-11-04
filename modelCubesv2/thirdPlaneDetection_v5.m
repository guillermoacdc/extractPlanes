function [thirdPlaneIndex, detectionFlag] = thirdPlaneDetection_v5(globalPlanes, ...
        targetP, secondP, searchSpace, crossPd_ref, th_angle, modelTree )
%THIRDPLANEDETECTION_V3  computes third plane based on section 4.1 in [1]
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf
% 
% _v5 uses the structure planesDescriptor with the fields (1) camerapose, (2) values

detectionFlag=false;
thirdPlaneIndex=[];


c_perpendicularityPos = searchCandidates3_perp_v1(searchSpace,...
    modelTree,crossPd_ref,th_angle);
c_perpendicularityNeg = searchCandidates3_perp_v1(searchSpace,...
    modelTree,-crossPd_ref,th_angle);
c_perpendicularity=[c_perpendicularityPos; c_perpendicularityNeg];

if ~isempty(c_perpendicularity)
%     %     add previous selected third plane
%     if ~isempty(globalPlanes(targetP).thirdPlaneID)
%         c_perpendicularity=[c_perpendicularity; globalPlanes(targetP).thirdPlaneID];
%     end
    c_convexity=searchCandidates3_conv_v2(globalPlanes, c_perpendicularity, targetP, secondP);
    if ~isempty(c_convexity)
        c_gcRelations=searchCandidates_geometriCenterRelationships(c_convexity,targetP,globalPlanes);
        if ~isempty(c_gcRelations)
        % select the candidate with minimal distance to target 
		    v1=globalPlanes(targetP).geometricCenter;			
		    dist_v=[];%clear the distance vector
	        for i=1:length(c_gcRelations)
			    candidateElement=c_gcRelations(i);	
			    v2=globalPlanes(candidateElement).geometricCenter;
		        dist_v(i)=norm(v1-v2);
            end
            [~,selectedIndex]=min(dist_v);
    
            thirdPlaneIndex=[c_gcRelations(selectedIndex)];
            detectionFlag=true;
        end
    end
end

end

