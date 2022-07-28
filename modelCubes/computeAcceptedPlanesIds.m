function [acceptedPlanes ] = computeAcceptedPlanesIds(myPlanes)
%COMPUTEALLPLANESIDS returns acceptedPlanes from an structure called
%myPlanes
%   Detailed explanation goes here
% _v2 works with two dimensional index in myPlanes
% _v3 returns acceptedPlanes

fields = fieldnames( myPlanes );
N1=size(fields,1);
acceptedPlanes=[];
for i=1:N1
    N2=size(myPlanes.(fields{i}).values,2);
    for j=1:N2
        if (myPlanes.(fields{i}).values(j).lengthFlag==0 & ( isempty(myPlanes.(fields{i}).values(j).DFlag) | myPlanes.(fields{i}).values(j).DFlag==0) )
            acceptedPlanes=[acceptedPlanes; myPlanes.(fields{i}).values(j).getID];
        end
%         all_IDs=[all_IDs; myPlanes.(fields{i}).values(j).getID];
    end
end
% all_IDs=setdiff_v2(all_IDs,globalRejectedPlanes);


end

