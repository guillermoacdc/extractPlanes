function [depth height width]=projectInEdge_v2(myPlanes,boxIDs)
%PROJECTINEDGE determine a size of a cuboid by projecting points on a plane
%into the edge, as described in section 4.3 from [1]
%   [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf

% compute p0 - for a single box

p1=myPlanes.(['fr' num2str(boxIDs(1))])(boxIDs(2)).geometricCenter;
n1=myPlanes.(['fr' num2str(boxIDs(1))])(boxIDs(2)).unitNormal';
p2=myPlanes.(['fr' num2str(boxIDs(3))])(boxIDs(4)).geometricCenter;
n2=myPlanes.(['fr' num2str(boxIDs(3))])(boxIDs(4)).unitNormal';
p3=myPlanes.(['fr' num2str(boxIDs(5))])(boxIDs(6)).geometricCenter;
n3=myPlanes.(['fr' num2str(boxIDs(5))])(boxIDs(6)).unitNormal';

p0=computeIntersectionBtwn3Planes(p1,p2,p3,n1,n2,n3);

% load points pc1, pc2, pc3
% pc1 = pcread(myPlanes{box.side1PlaneID}.pathPoints);%in [mt]; indices begin at 0
pc1 = pcread(myPlanes.(['fr' num2str(boxIDs(1))])(boxIDs(2)).pathPoints);%in [mt]; indices begin at 0
modelParameters=[myPlanes.(['fr' num2str(boxIDs(1))])(boxIDs(2)).unitNormal,...
    myPlanes.(['fr' num2str(boxIDs(1))])(boxIDs(2)).D];
pc1 = projectInPlane(pc1,modelParameters);

pc2 = pcread(myPlanes.(['fr' num2str(boxIDs(3))])(boxIDs(4)).pathPoints);%in [mt]; indices begin at 0
modelParameters=[myPlanes.(['fr' num2str(boxIDs(3))])(boxIDs(4)).unitNormal,...
    myPlanes.(['fr' num2str(boxIDs(3))])(boxIDs(4)).D];
pc2 = projectInPlane(pc2,modelParameters);

pc3 = pcread(myPlanes.(['fr' num2str(boxIDs(5))])(boxIDs(6)).pathPoints);%in [mt]; indices begin at 0
modelParameters=[myPlanes.(['fr' num2str(boxIDs(5))])(boxIDs(6)).unitNormal,...
    myPlanes.(['fr' num2str(boxIDs(5))])(boxIDs(6)).D];
pc3 = projectInPlane(pc3,modelParameters);

% project pmaxi into two adjacent normals and save the result (L1, L2) with
% L1<L2. For each pmaxi we expect two projections, i.e.: 
% pmax1_projn2
% pmax1_projn3
[pmax1_projn2 pmax1_projn3] = computeFartherPoint(p0,pc1, -n2, -n3);
% pmax2_projn1
% pmax2_projn3
[pmax2_projn1 pmax2_projn3] = computeFartherPoint(p0,pc2, -n1, -n3);
% pmax3_projn1
% pmax3_projn2
[pmax3_projn1 pmax3_projn2] = computeFartherPoint(p0,pc3, -n1, -n2);

% compute the mean between _projn1 as height
height=mean([pmax2_projn1, pmax3_projn1]);

depth=mean([pmax1_projn2,pmax3_projn2]); 
 
width=mean([pmax1_projn3,pmax2_projn3]);

if(depth>width)
% swap
    aux=depth;
    depth=width;
    width=aux;
end



end

