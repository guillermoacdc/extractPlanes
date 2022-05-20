function [thirdPlaneIndex detectionFlag] = thirdPlaneDetection_v3(myPlanes, ...
        targetP, secondP, acceptedPlanes, crossPd_ref, th_angle, exemplarSet)
%THIRDPLANEDETECTION_V3  computes third plane based on section 4.1 in [1]
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf
% 
detectionFlag=false;
thirdPlaneIndex=[];
targetFrame=targetP(1);
targetElement=targetP(2);
secondFrame=secondP(1);
secondElement=secondP(2);
c_perpendicularity=[];
c_convexity=[];

c_perpendicularity = searchCandidates3_perp(acceptedPlanes,...
    exemplarSet,crossPd_ref,th_angle);
if ~isempty(c_perpendicularity)
    %     add previous selected third plane
    if ~isempty(myPlanes.(['fr' num2str(targetFrame)])(targetElement).thirdPlaneID)
        c_perpendicularity=[c_perpendicularity; myPlanes.(['fr' num2str(targetFrame)])(targetElement).thirdPlaneID];
    end
    c_convexity=searchCandidates3_conv(myPlanes, c_perpendicularity, targetP, secondP);
    if ~isempty(c_convexity)
%         update by creating an indicator of distance to both, target and
%         second plane

    % select the candidate with minimal distance to target 
		v1=myPlanes.(['fr' num2str(targetFrame)])(targetElement).geometricCenter;			
		dist_v=[];%clear the distance vector
		for (ii=1:1:size(c_convexity,1))
		    candidateFrame=c_convexity(ii,1);
			candidateElement=c_convexity(ii,2);	
			v2=myPlanes.(['fr' num2str(candidateFrame)])(candidateElement).geometricCenter;
		    dist_v(ii)=norm(v1-v2);
        end
        [~,selectedIndex]=min(dist_v);

        thirdPlaneIndex=[c_convexity(selectedIndex,:)];
        detectionFlag=true;
    end
end

end

