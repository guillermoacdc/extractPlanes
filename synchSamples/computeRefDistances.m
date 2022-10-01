function d=computeRefDistances(position,markerIDRef)
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
    d=zeros(3,4);
    for i=1:length(markerIDs)
        d(:,i)=position.(['M00' num2str(markerIDs(i))])'-dref;
    end


end

