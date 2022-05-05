function candidates1_v2=extract2dIndexes(candidates1, acceptedPlanes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i=1:size(candidates1,2)
    candidates1_v2(i) = acceptedPlanes(candidates1(i));
end
end

