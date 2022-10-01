function d=computeRefDistances_v2(position,markerIDRef)
%COMPUTEREFDISTANCES Summary of this function goes here
%   Detailed explanation goes here
    markerIDs=[0 3 4 5 6];
    
    % convert markerIDref to indexRef
    indexRef=find(markerIDs==markerIDRef);
    % extract dref as a column vector
    dref=position.(['M00' num2str(markerIDs(indexRef))])';
    % eliminate markerIDRef from markerIDs
    markerIDs(indexRef)=[];
    
    % compute distance of other points wrt indexRef
%     d=zeros(3,4);
%     for i=1:length(markerIDs)
%         d(:,i)=position.(['M00' num2str(markerIDs(i))])'-dref;
%     end

% create a version independent of the reference. You can use eval function
d0=nanmean(position.M000'-dref,2);
d4=nanmean(position.M004'-dref,2);
d5=nanmean(position.M005'-dref,2);
d6=nanmean(position.M006'-dref,2);

d=[d0 d4 d5 d6];

end

