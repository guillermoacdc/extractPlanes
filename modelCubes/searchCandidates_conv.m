function candidate = searchCandidates_conv(c_perpendicularity, frame_tp, element_tp, planesDescriptor)
%SEARCHCANDIDATES_CONV search candidates by using convexity criterion
%   Detailed explanation goes here
candidate=[];
k=1;
for i=1:1:size(c_perpendicularity,1)
    frame_ss=c_perpendicularity(i,1);
%     element_ss=searchSpace(c_perpendicularity(i,2),2);
    element_ss=c_perpendicularity(i,2);
    convFlag=convexityCheck(planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).unitNormal,...
        planesDescriptor.(['fr' num2str(frame_tp)])(element_tp).geometricCenter,...
        planesDescriptor.(['fr' num2str(frame_ss)])(element_ss).unitNormal,...
        planesDescriptor.(['fr' num2str(frame_ss)])(element_ss).geometricCenter);

    if (convFlag)
        candidate(k,:)=[frame_ss element_ss];
        k=k+1;
    end
end
end

