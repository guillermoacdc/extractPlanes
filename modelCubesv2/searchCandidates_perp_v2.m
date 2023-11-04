function candidatesIndex = searchCandidates_perp_v2(searchSpaceT, targetIndex,  globalPlanes, th_angle)
%SEARCHCANDIDATES_PERP search candidatesIndex by using perpendicularity
%criterion
% _v2 uses the structure globalPlanes with the fields (1) camerapose, (2) values
normTarget=globalPlanes(targetIndex).unitNormal;
candidatesIndex=[];
k=1; 
for i=1:1:size(searchSpaceT,1)
%     perpCriterion1=false;
    normCandidate=globalPlanes(searchSpaceT(i)).unitNormal;
    beta=computeAngleBtwnVectors(normTarget,normCandidate);
    perpCriterion1=(abs(cos(beta*pi/180))< cos (pi/2-th_angle));

    if isempty(globalPlanes(targetIndex).thirdPlaneID)
    % version for a plane without third plane selected
        if perpCriterion1
            candidatesIndex(k,:)=searchSpaceT(i);%updated with local indexes
            k=k+1;
        end
    end
end

end

