function [secondPlaneIndex] = secondPlaneDetection_v2(targetPlane,searchSpace,planesDescriptor, th_angle )
%SECONPLANEDETECTION Summary of this function goes here
%   computes second plane based on section 4.1 in [1]
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf
% 
% _v2 is the identifier for the two dimensional version in the index of the
% planes. each index has the form [v1 v2], where v1 is the frame id and v2
% is the plane id

candidates1=[];
candidates2=[];
k=1;
frame_tp=targetPlane(1,1);
element_tp=targetPlane(1,2);
searchSpaceT=searchSpace;
%% select candidates by perpendicularity criterion
% add previously secondPlane selected to the search space
if ~isempty(planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).secondPlaneID)
    searchSpaceT=[searchSpaceT; planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).secondPlaneID];
    searchSpaceT=unique(searchSpaceT,'rows','stable');%avoid duplicates
end

normTarget=planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).unitNormal;

for i=1:1:size(searchSpaceT,1)
    perpCriterion=false;  
    frame_ss=searchSpaceT(i,1);
    element_ss=searchSpaceT(i,2);
    normCandidate=planesDescriptor.(['fr' num2str(frame_ss)])(element_ss).unitNormal;
    beta=computeAngleBtwnVectors(normTarget,normCandidate);
    perpCriterion=(abs(cos(beta*pi/180))< cos (pi/2-th_angle));

    if isempty(planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).thirdPlaneID)
    % version for a plane without third plane selected
        if perpCriterion
            candidates1(k,:)=[frame_ss element_ss];%updated with local indexes
            k=k+1;
        end
    
    else
    % version for a plane with a third plane selected
        perpCriterion2=false;
        thirdPlaneID=planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).thirdPlaneID;
        normThirdPlane=planesDescriptor.(['fr' num2str(thirdPlaneID(1))])(thirdPlaneID(2)).unitNormal;
        beta=computeAngleBtwnVectors(normThirdPlane,normCandidate);
        perpCriterion2=(abs(cos(beta*pi/180))< cos (pi/2-th_angle));
        if perpCriterion & perpCriterion2
            candidates1(k,:)=[frame_ss element_ss];%updated with local indexes
            k=k+1;
        end
    end
end


if (isempty(candidates1))
    secondPlaneIndex=-1;

    return
end
%% select candidates by convexity criterion
k=1;
for(i=1:1:size(candidates1,1))

    frame_ss=candidates1(i,1);
%     element_ss=searchSpace(candidates1(i,2),2);
    element_ss=candidates1(i,2);
    convFlag=convexityCheck(planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).unitNormal,...
        planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).geometricCenter,...
        planesDescriptor.(['fr' num2str(frame_ss)])(element_ss).unitNormal,...
        planesDescriptor.(['fr' num2str(frame_ss)])(element_ss).geometricCenter);

    if (convFlag)
        candidates2(k,:)=[frame_ss element_ss];
        k=k+1;
    end
end

if (isempty(candidates2))
    secondPlaneIndex=-1;

    return
end

%% select candidates by distance criterion
v1=planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).geometricCenter;
for i=1:1:size(candidates2,1)
    frame_ss=candidates2(i,1);
    element_ss=candidates2(i,2);
    v2=planesDescriptor.(['fr' num2str(frame_ss)])(element_ss).geometricCenter;
    dist_v(i)=norm(v1-v2);
end
[~,selectedIndex]=min(dist_v);
secondPlaneIndex(1,1)=candidates2(selectedIndex,1);
secondPlaneIndex(1,2)=candidates2(selectedIndex,2);

end


