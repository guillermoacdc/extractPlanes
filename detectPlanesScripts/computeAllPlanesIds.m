function [all_IDs] = computeAllPlanesIds(myPlanes)
%COMPUTEALLPLANESIDS Summary of this function goes here
%   Detailed explanation goes here
% _v2 works with two dimensional index in myPlanes


fields = fieldnames( myPlanes );
N1=size(fields,1);
all_IDs=[];
for i=1:N1
    N2=size(myPlanes.(fields{i}).values,2);
    for j=1:N2
        all_IDs=[all_IDs; myPlanes.(fields{i}).values(j).getID];
    end
end
% all_IDs=setdiff_v2(all_IDs,globalRejectedPlanes);


end

