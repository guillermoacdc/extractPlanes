function candidates = searchCandidates3_conv_v2(globalPlanes, searchSpace, targetElement, secondElement)
%SEARCHCANDIDATES3_CONV Summary of this function goes here
%   Detailed explanation goes here
% _v2 uses the structure planesDescriptor with the fields (1) camerapose, (2) values

% targetFrame=targetP(1);
% targetElement=targetP(2);
% secondFrame=secondP(1);
% secondElement=secondP(2);
k=1;
candidates=[];
% select candidates by convexity criterion
    for ii=1:1:length(searchSpace)
%         candidateFrame=searchSpace(ii,1);
	    candidateElement=searchSpace(ii);
    	%convexity btwn target and candidate
	    n1=globalPlanes(targetElement).unitNormal;
		gc1=globalPlanes(targetElement).geometricCenter;
		n2=globalPlanes(candidateElement).unitNormal;
		gc2=globalPlanes(candidateElement).geometricCenter;
		convFlag1=convexityCheck(n1,gc1,n2,gc2);
		%convexity between secondPlane and candidate
		n1=globalPlanes(secondElement).unitNormal;
		gc1=globalPlanes(secondElement).geometricCenter;
		convFlag2=convexityCheck(n1,gc1,n2,gc2);
        if (convFlag1 & convFlag2)
%             candidates(k,1)=candidateFrame;
			candidates(k)=candidateElement;
            k=k+1;
        end
    end
end

