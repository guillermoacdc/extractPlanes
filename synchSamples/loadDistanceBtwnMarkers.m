function pB_candidates=loadDistanceBtwnMarkers(rootPath,scene)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

pB_candidates=ones(4);
pB_candidates(1:4,1:3)=importdata(rootPath + 'scene' + num2str(scene) + '\HLMarkersDistance_m3ref.txt');



end

