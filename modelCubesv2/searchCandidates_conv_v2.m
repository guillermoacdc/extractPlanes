function candidate = searchCandidates_conv_v2(searchSpace, targetIndex, globalPlanes)
%SEARCHCANDIDATES_CONV search candidates by using convexity criterion
%   Detailed explanation goes here
% _v2 uses the structure globalPlanes with the fields (1) camerapose, (2) values
candidate=[];
k=1;
Nss=length(searchSpace);
for i=1:Nss
    element_ss=searchSpace(i);
    convFlag=convexityCheck(globalPlanes(targetIndex).unitNormal,...
        globalPlanes(targetIndex).geometricCenter,...
        globalPlanes(element_ss).unitNormal,...
        globalPlanes(element_ss).geometricCenter);

    if (convFlag)
        candidate(k,:)=[element_ss];
        k=k+1;
    end
end
end

