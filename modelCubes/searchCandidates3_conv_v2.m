function candidates = searchCandidates3_conv_v2(myPlanes, searchSpace, targetP, secondP)
%SEARCHCANDIDATES3_CONV Summary of this function goes here
%   Detailed explanation goes here
% _v2 uses the structure planesDescriptor with the fields (1) camerapose, (2) values

targetFrame=targetP(1);
targetElement=targetP(2);
secondFrame=secondP(1);
secondElement=secondP(2);
k=1;
candidates=[];
% select candidates by convexity criterion
    for ii=1:1:size(searchSpace,1)
        candidateFrame=searchSpace(ii,1);
	    candidateElement=searchSpace(ii,2);
    	%convexity btwn target and candidate
	    n1=myPlanes.(['fr' num2str(targetFrame)]).values(targetElement).unitNormal;
		gc1=myPlanes.(['fr' num2str(targetFrame)]).values(targetElement).geometricCenter;
		n2=myPlanes.(['fr' num2str(candidateFrame)]).values(candidateElement).unitNormal;
		gc2=myPlanes.(['fr' num2str(candidateFrame)]).values(candidateElement).geometricCenter;
		convFlag1=convexityCheck(n1,gc1,n2,gc2);
		%convexity between secondPlane and candidate
		n1=myPlanes.(['fr' num2str(secondFrame)]).values(secondElement).unitNormal;
		gc1=myPlanes.(['fr' num2str(secondFrame)]).values(secondElement).geometricCenter;
		convFlag2=convexityCheck(n1,gc1,n2,gc2);
        if (convFlag1 & convFlag2)
            candidates(k,1)=candidateFrame;
			candidates(k,2)=candidateElement;
            k=k+1;
        end
    end
end

