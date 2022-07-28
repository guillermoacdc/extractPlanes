
% test 3.
% global planes: accepted planes in frame 4
% idx=12; corresponds with plane 4-12
% local plane: plane 54-3
% Expected result: global Planes are updated in index 10 with plane 54-3
myGlobalIdxs=[4     3;      4     4;      4     5;      4     6;     4     7;      4     8;      4     9;     4    10;     4    11;     4    12;     4    14;     4    17;     4    18];
myLocalId=[54 3];
idx=10;

% obtain planes from Ids
globalPlanes=myPlanes.(['fr' num2str(myGlobalIdxs(idx,1))]).values;
localPlane=myPlanes.(['fr' num2str(myLocalId(1))]).values(myLocalId(2));

% figure,
% myPlotPlanes_v2(myPlanes, myGlobalIdxs)
% hold on
% myPlotPlanes_v2(myPlanes, myLocalId)


% compute type of twin
typeT = computeTypeOfTwin(localPlane,globalPlanes(myGlobalIdxs(idx,2)));
% perform merge
dc = computeDistanceToCamera(myPlanes,myLocalId);
thd_lower=1;%measures with distances lower than 1 mt are rejected
thd_upper=3;%measures with distances higher than 3 mt are rejected
% A_l=localPlane.L1*localPlane.L2;
% A_g=globalPlanes(myGlobalIdxs(idx,2)).L1*globalPlanes(myGlobalIdxs(idx,2)).L2;
dl=computeDistanceToCamera(myPlanes,myLocalId);
dg=computeDistanceToCamera(myPlanes,myGlobalIdxs);
globalPlanes=performMerge(localPlane,globalPlanes, idx, typeT, A_l, A_g, dl, dg);

return



% test 2.
% global planes: accepted planes in frame 2
% idx=2; corresponds with plane 2-3
% local plane: plane 5-7
% Expected result: global Planes are updated with plane 5-7 in index 2
myGlobalIdxs=[2     2;      2     3;     2     6;     2     8;     2     9;     2    10;    2    11;    2    14];
myLocalId=[5 7];
idx=2;

% obtain planes from Ids
globalPlanes=myPlanes.(['fr' num2str(myGlobalIdxs(idx,1))]).values;
localPlane=myPlanes.(['fr' num2str(myLocalId(1))]).values(myLocalId(2));

figure,
myPlotPlanes_v2(myPlanes, myGlobalIdxs)
hold on
myPlotPlanes_v2(myPlanes, myLocalId)


% compute type of twin
typeT = computeTypeOfTwin(localPlane,globalPlanes(myGlobalIdxs(idx,2)));
% perform merge
dc = computeDistanceToCamera(myPlanes,myLocalId);
thd_lower=1;%measures with distances lower than 1 mt are rejected
thd_upper=3;%measures with distances higher than 3 mt are rejected
% globalPlanes=performMerge(localPlane,globalPlanes, idx, typeT, dc, thd_lower, thd_upper);
A_l=localPlane.L1*localPlane.L2;
A_g=globalPlanes(myGlobalIdxs(idx,2)).L1*globalPlanes(myGlobalIdxs(idx,2)).L2;
globalPlanes=performMerge(localPlane,globalPlanes, idx, typeT, A_l, A_g);
return

% test 1.
% global planes: accepted planes in frame 2
% idx=8; corresponds with plane 2-14
% local plane: plane 3-7
% Expected result: global Planes do not change
myGlobalIdxs=[2     2;      2     3;     2     6;     2     8;     2     9;     2    10;    2    11;    2    14];
myLocalId=[3 7];
idx=8;

% obtain planes from Ids
globalPlanes=myPlanes.(['fr' num2str(myGlobalIdxs(idx,1))]).values;
localPlane=myPlanes.(['fr' num2str(myLocalId(1))]).values(myLocalId(2));
% compute type of twin
typeT = computeTypeOfTwin(localPlane,globalPlanes(myGlobalIdxs(idx,2)));
% perform merge
dc = computeDistanceToCamera(myPlanes,myLocalId);
thd_lower=1;%measures with distances lower than 1 mt are rejected
thd_upper=3;%measures with distances higher than 3 mt are rejected
% globalPlanes=performMerge(localPlane,globalPlanes, idx, typeT, dc, thd_lower, thd_upper);
A_l=localPlane.L1*localPlane.L2;
A_g=globalPlanes(myGlobalIdxs(idx,2)).L1*globalPlanes(myGlobalIdxs(idx,2)).L2;
globalPlanes=performMerge(localPlane,globalPlanes, idx, typeT, A_l, A_g);


% plot the planes
figure,
myPlotPlanes_v2(myPlanes, myGlobalPlanes)
hold on
myPlotPlanes_v2(myPlanes, myLocalPlane)


