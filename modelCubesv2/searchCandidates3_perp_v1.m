function candidates = searchCandidates3_perp_v1(searchSpace, ...
    modelTree,refSearch,th_angle)
%SEARCHCANDIDATES3_PERP Summary of this function goes here
%   Detailed explanation goes here
% v1: implementation with kdtreesearcher. Requires a 3-d tree in the input,
% instead of exemplarSet

indexmt=rangesearch(modelTree,refSearch,th_angle*180/(100*pi));

% convert index into two dimensional IDs of planes
candidates=[];

for i=1:size(indexmt{1},2)
    candidates=[candidates; searchSpace(indexmt{1}(i))]; 
end


end



