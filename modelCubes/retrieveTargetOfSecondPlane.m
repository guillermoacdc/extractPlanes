function [targetOfSecondPlane] = retrieveTargetOfSecondPlane(myPlanes, secondPlaneIdx)
%RETRIEVESECONDPLANES Performs a search of secondPlane Index between the
%current myPlanes. If found it, retrives the associated target:
%targetOfSecondPlane
%   Detailed explanation goes here

fields = fieldnames( myPlanes );
N1=size(fields,1);
targetOfSecondPlane=[];
for i=1:N1
    N2=size(myPlanes.(fields{i}),2);
    for j=1:N2
        if isempty(myPlanes.(fields{i})(j).secondPlaneID)
            condition=[false false];
        else
            condition=myPlanes.(fields{i})(j).secondPlaneID==secondPlaneIdx;
        end
        if condition(1) & condition(2)
            targetOfSecondPlane=[targetOfSecondPlane; myPlanes.(fields{i})(j).getID];
        end
    end
end

end




