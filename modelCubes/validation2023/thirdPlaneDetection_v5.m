function [thirdPlaneIndex detectionFlag] = thirdPlaneDetection_v5(myPlanes, ...
        targetP, secondP, acceptedPlanes, crossPd_ref, th_angle, modelTree )
%THIRDPLANEDETECTION_V3  computes third plane based on section 4.1 in [1]
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf
% 
% _v5 uses the structure planesDescriptor with the fields (1) camerapose, (2) values
detectionFlag=false;
thirdPlaneIndex=[];
targetFrame=targetP(1);
targetElement=targetP(2);
secondFrame=secondP(1);
secondElement=secondP(2);
c_perpendicularity=[];
c_convexity=[];

c_perpendicularity = searchCandidates3_perp_v1(acceptedPlanes,...
    modelTree,crossPd_ref,th_angle);
if ~isempty(c_perpendicularity)
    %     add previous selected third plane
    if ~isempty(myPlanes.(['fr' num2str(targetFrame)]).values(targetElement).thirdPlaneID)
        c_perpendicularity=[c_perpendicularity; myPlanes.(['fr' num2str(targetFrame)]).values(targetElement).thirdPlaneID];
    end
    c_convexity=searchCandidates3_conv_v2(myPlanes, c_perpendicularity, targetP, secondP);
    if ~isempty(c_convexity)
%         update by creating an indicator of distance to both, target and
%         second plane

    % select the candidate with minimal distance to target 
		v1=myPlanes.(['fr' num2str(targetFrame)]).values(targetElement).geometricCenter;			
		dist_v=[];%clear the distance vector
		for (ii=1:1:size(c_convexity,1))
		    candidateFrame=c_convexity(ii,1);
			candidateElement=c_convexity(ii,2);	
			v2=myPlanes.(['fr' num2str(candidateFrame)]).values(candidateElement).geometricCenter;
		    dist_v(ii)=norm(v1-v2);
        end
        [~,selectedIndex]=min(dist_v);

        thirdPlaneIndex=[c_convexity(selectedIndex,:)];
        detectionFlag=true;
    end
end

end

