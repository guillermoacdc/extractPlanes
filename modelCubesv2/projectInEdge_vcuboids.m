function [width, depth, height]=projectInEdge_vcuboids(globalPlanes,group_tpp)
%PROJECTINEDGE determine a size of a cuboid by projecting points on a plane
%into the edge, as described in section 4.3 from [1]
%   [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf

%% compute p0 - for a single box
% extract geometric center and normal
p1=globalPlanes(group_tpp(1)).geometricCenter;
p2=globalPlanes(group_tpp(2)).geometricCenter;
p3=globalPlanes(group_tpp(3)).geometricCenter;

% n1=globalPlanes(group_tpp(1)).unitNormal';
% n2=globalPlanes(group_tpp(2)).unitNormal';
% n3=globalPlanes(group_tpp(3)).unitNormal';
n1=globalPlanes(group_tpp(1)).tform(1:3,2);
n2=globalPlanes(group_tpp(2)).tform(1:3,3);
n3=globalPlanes(group_tpp(3)).tform(1:3,3);


% compute p0
p0=computeIntersectionBtwn3Planes(p1,p2,p3,n1,n2,n3);

% load point clouds pc1, pc2, pc3
for i=1:3%operates for triads of planes
    splane=globalPlanes(group_tpp(i));
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



% validation plot: point clouds, plane segments, intersection point and
% ground truth poses
sessionID=10;
dataSetPath=computeReadPaths(sessionID);
frameID=84;
syntheticPlaneType=4;
planeDesc_m=loadInitialPose_v3(dataSetPath,sessionID,frameID,syntheticPlaneType);
Th2m=loadTh2m(dataSetPath,sessionID);
Tm2h=inv(Th2m);
% project poses
planeDesc_h=projectPose(planeDesc_m,Tm2h);
Nb=size(planeDesc_h,2);
% 
figure,
    myPlotPlanes_v3(globalPlanes(group_tpp),1)
    plot3(p0(1),p0(2),p0(3),'yo')
    for k =1:Nb
        T=planeDesc_h(k).tform;
        ind=planeDesc_h(k).idBox;
        dibujarsistemaref(T,ind,120,2,10,'w');
        hold on
    end
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
end

% NpointsDiagTopSide=30
% pc = createSyntheticPC_v2(planeDesc_m,NpointsDiagTopSide,boxID, gridStep, dataSetPath)
% compute Tm2h