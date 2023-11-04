function [couple1, couple2, couple3] = classifyCouples_vcuboids(couples,globalPlanes)
%CLASSIFYCOUPLES Classify couples of planes in the categories:
% couple1: {xyPlane, xzPlane}
% couple2: {zyPlane, xzPlane}
% couple3: {xyPlane, zyPlane}
%   Detailed explanation goes here
% input - couples: a vector with indexes and size Nx4; colums 1 to 2
% contain the identifier of target plane, columns 3 to 4 contain the
% identifier of the second plane
% input - globalPlanes: cell of objects with descreiptors of all available planes

couple1=[];
couple2=[];
couple3=[];

for i=1:size(couples,1)
    indexTopPlane=couples(i,1);
    indexPerpPlane=couples(i,2);
    p1type=globalPlanes(indexTopPlane).type;
    %convert to boolean
    p1type=logical(p1type);
    p2type=globalPlanes(indexPerpPlane).type;
    %convert to boolean
    p2type=logical(p2type);

    p1Tilt=globalPlanes(indexTopPlane).planeTilt;
    p2Tilt=globalPlanes(indexPerpPlane).planeTilt;

    if p1type & p2type%is couple 3?
        couple3=[couple3; couples(i,:)];
    else
        if  (~p1type)*p2type*(~p2Tilt) | p1type*(~p1Tilt)*(~p2type) %is couple 2?
            couple2=[couple2; couples(i,:)];
        else
            if (~p1type)*p2type*p2Tilt | p1type*p1Tilt*(~p2type) %is couple 1?
                couple1=[couple1; couples(i,:)];
            end
        end
    end
end

end

