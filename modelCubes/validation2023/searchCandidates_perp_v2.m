function candidates = searchCandidates_perp_v2(frame_tp, element_tp, searchSpaceT, planesDescriptor, th_angle)
%SEARCHCANDIDATES_PERP search candidates by using perpendicularity
%criterion
% _v2 uses the structure planesDescriptor with the fields (1) camerapose, (2) values
normTarget=planesDescriptor.(['fr' num2str(frame_tp)]).values(element_tp).unitNormal;
candidates=[];
k=1; 
for i=1:1:size(searchSpaceT,1)
    perpCriterion1=false;
    frame_ss=searchSpaceT(i,1);
    element_ss=searchSpaceT(i,2);
    normCandidate=planesDescriptor.(['fr' num2str(frame_ss)]).values(element_ss).unitNormal;
    beta=computeAngleBtwnVectors(normTarget,normCandidate);
    perpCriterion1=(abs(cos(beta*pi/180))< cos (pi/2-th_angle));

    if isempty(planesDescriptor.(['fr' num2str(frame_tp)]).values(element_tp).thirdPlaneID)
    % version for a plane without third plane selected
        if perpCriterion1
            candidates(k,:)=[frame_ss element_ss];%updated with local indexes
            k=k+1;
        end
    
    else
    % version for a plane with a third plane selected
        perpCriterion2=false;
        thirdPlaneID=planesDescriptor.(['fr' num2str(frame_tp)]).values(element_tp).thirdPlaneID;
        normThirdPlane=planesDescriptor.(['fr' num2str(thirdPlaneID(1))]).values(thirdPlaneID(2)).unitNormal;
        beta=computeAngleBtwnVectors(normThirdPlane,normCandidate);
        perpCriterion2=(abs(cos(beta*pi/180))< cos (pi/2-th_angle));
        if perpCriterion1 & perpCriterion2
            candidates(k,:)=[frame_ss element_ss];%updated with local indexes
            k=k+1;
        end
    end
end

end

