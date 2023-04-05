% Note. On these tests we are not satisfying the assumption of equal type
% between planes before the twin search. This assumption must be
% implemented in the integrated version of this code to reduce
% computational complexity

% test2
% globalPlanes: planes in frame 2
% localPlanes: planes in frame 5
% expected results: (1) keep planes of global frames, (2) replace plane 2-3
% with plane 5-7, (3) replace plane 2-6
% with plane 5-5, (4) create planes 5-8, 5-9, and others.. 
% note that planes (5-6, 5-5), (5-10,5-7) represent a case of twin planes
% in the same frame

% Notes on fails
% fails in fusion btwn 2-8,5-11. Create a test in computeTypeOfTwin_test.m

% framework
% create plane 5-15
globalPlanesIDs=[2     2;      2     3;      2     6;     2     8;     2     9;     2    10;     2    11;     2    14];
localPlanesIDs=[ 5     2;      5     3;     5     4;     5     5;     5     6;     5     7;     5     8;     5     9;     5    10;     5    11;     5    12;     5    13;     5    14;     5    15;     5    16;     5    17];

figure,
% myPlotPlanes_v2(myPlanes, globalPlanesIDs)
% hold on
myPlotPlanes_v2(myPlanes, localPlanesIDs)

% convert IDs to vector of datum
globalPlanes=loadPlanesFromIDs(myPlanes,globalPlanesIDs);
localPlanes=loadPlanesFromIDs(myPlanes,localPlanesIDs);
% load distances
dc_g=computeDistanceToCamera(myPlanes,globalPlanesIDs);
dc_l=computeDistanceToCamera(myPlanes,localPlanesIDs);

%  merge
globalPlanes = mergeIntoGlobalPlanes(localPlanes,globalPlanes, dc_l, dc_g);
globalIDs=extractIDsFromVector(globalPlanes);
figure,
myPlotPlanes_v2(myPlanes, globalIDs)

% % test1
% % globalPlanes: planes in frame 2
% % localPlanes: planes in frame 3
% % expected results: discard all localPlanes and keep globalPlanes; all
% % cases are non occluded planes
% 
% globalPlanesIDs=[2     2;      2     3;      2     6;     2     8;     2     9;     2    10;     2    11;     2    14];
% localPlanesIDs=[3     2;     3     5;     3     6;     3     7;     3     8;     3     9;     3    10;    3    11];
% 
% globalPlanes=loadPlanesFromIDs(myPlanes,globalPlanesIDs);
% localPlanes=loadPlanesFromIDs(myPlanes,localPlanesIDs);
% 
% globalPlanes = mergeIntoGlobalPlanes(localPlanes,globalPlanes)

return
