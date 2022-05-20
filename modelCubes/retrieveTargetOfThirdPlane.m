function [targetOfThirdPlane] = retrieveTargetOfThirdPlane(myPlanes, thirdPlaneIdx)
%RETRIEVESECONDPLANES Performs a search of thirdPlane Index between the
%current myPlanes. If found it, retrives the associated target:
%targetOfThirdPlane
%   Detailed explanation goes here

fields = fieldnames( myPlanes );
N1=size(fields,1);
targetOfThirdPlane=[];
for i=1:N1
    N2=size(myPlanes.(fields{i}),2);
    for j=1:N2
        if isempty(myPlanes.(fields{i})(j).thirdPlaneID)
            condition=[false false];
        else
            condition=myPlanes.(fields{i})(j).thirdPlaneID==thirdPlaneIdx;
        end
        
        if condition(1) & condition(2)
            targetOfThirdPlane=[targetOfThirdPlane; myPlanes.(fields{i})(j).getID];
        end
    end
end

end




