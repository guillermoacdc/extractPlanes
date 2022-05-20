function [targetOfSecondPlane] = retrieveTargetOfSecondPlane(myPlanes, secondPlaneIdx)
%RETRIEVESECONDPLANES Summary of this function goes here
%   Detailed explanation goes here

fields = fieldnames( myPlanes );
N1=size(fields,1);
targetOfSecondPlane=[];
for i=1:N1
    N2=size(myPlanes.(fields{i}),2);
    for j=1:N2
        condition=myPlanes.(fields{i})(j).secondPlaneID==secondPlaneIdx;
        if condition(1) & condition(2)
            targetOfSecondPlane=[targetOfSecondPlanes; myPlanes.(fields{i})(j).getID];
        end
    end
end

end




