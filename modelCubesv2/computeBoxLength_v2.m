function [width, depth, height]=computeBoxLength_v2(globalPlanes,triadIndex)
%COMPUTEBOXLENGTH Computes the length of a box composed by three
%orthogonal planes. The computation is based on projections of inliers of
%each plane along the normal of adjacent planes as explained in in section 
% 4.3 from [1]
%   [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf

% Assumptions: the first plane in the set triadIndex is a top plane

%% compute p0 - for a single box
% extract geometric center and normal
p1=globalPlanes(triadIndex(1)).geometricCenter;
p2=globalPlanes(triadIndex(2)).geometricCenter;
p3=globalPlanes(triadIndex(3)).geometricCenter;

% n1=globalPlanes(triadIndex(1)).unitNormal';
% n2=globalPlanes(triadIndex(2)).unitNormal';
% n3=globalPlanes(triadIndex(3)).unitNormal';
n1=globalPlanes(triadIndex(1)).tform(1:3,2);
n2=globalPlanes(triadIndex(2)).tform(1:3,3);
n3=globalPlanes(triadIndex(3)).tform(1:3,3);


% compute p0
p0=computeIntersectionBtwn3Planes(p1,p2,p3,n1,n2,n3);

% load point clouds pc1, pc2, pc3
for i=1:3%operates for triads of planes
    splane=globalPlanes(triadIndex(i));
    if splane.idFrame==0
        pc=myPCreadComposedPlane_soft(splane.pathPoints);
    else
        pc=myPCread(splane.pathPoints);
    end
    modelParameters=[splane.unitNormal splane.D];
    pc_group{i}=projectInPlane(pc,modelParameters);
end
% validar si requiere conversiones especiales de cell a pointcloud
pc1=pc_group{1};
pc2=pc_group{2};
pc3=pc_group{3};

% project pmaxi into two adjacent normals and save the result (L1, L2) with
% L1<L2. For each pmaxi we expect two projections, i.e.: 
[pmax1_projn2, pmax1_projn3]  = computeFartherPoint(p0,pc1, -n2, -n3);
[pmax2_projn1, pmax2_projn3]   = computeFartherPoint(p0,pc2, -n1, -n3);
[pmax3_projn1, pmax3_projn2]  = computeFartherPoint(p0,pc3, -n1, -n2);

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

