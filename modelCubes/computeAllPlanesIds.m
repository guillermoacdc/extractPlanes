function [all_IDs] = computeAllPlanesIds(myPlanes, globalRejectedPlanes)
%COMPUTEALLPLANESIDS Summary of this function goes here
%   Detailed explanation goes here


fields = fieldnames( myPlanes );
N1=size(fields,1);
all_IDs=[];
for i=1:N1
    N2=size(myPlanes.(fields{i}),2);
    for j=1:N2
        all_IDs=[all_IDs; myPlanes.(fields{i})(j).getID];
    end
end
all_IDs=setdiff_v2(all_IDs,globalRejectedPlanes);


end

