function [depth height width]=projectInEdgev2(myPlanes, topPlaneID, side1PlaneID, side2PlaneID, plotFlag)
%PROJECTINEDGE determine a size of a cuboid by projecting points on a plane
%into the edge, as described in section 4.3 from [1]
%   [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf

% compute p0 - for a single box
p1=myPlanes{side1PlaneID}.geometricCenter;
n1=myPlanes{side1PlaneID}.unitNormal';
p2=myPlanes{side2PlaneID}.geometricCenter;
n2=myPlanes{side2PlaneID}.unitNormal';
p3=myPlanes{topPlaneID}.geometricCenter;
n3=myPlanes{topPlaneID}.unitNormal';
p0=computeIntersectionBtwn3Planes(p1,p2,p3,n1,n2,n3);

% load points pc1, pc2, pc3
pc1 = pcread(myPlanes{side1PlaneID}.pathPoints);%in [mt]; indices begin at 0
modelParameters=[myPlanes{side1PlaneID}.unitNormal myPlanes{side1PlaneID}.D];
pc1 = projectInPlane(pc1,modelParameters);

pc2 = pcread(myPlanes{side2PlaneID}.pathPoints);%in [mt]; indices begin at 0
modelParameters=[myPlanes{side2PlaneID}.unitNormal myPlanes{side2PlaneID}.D];
pc2 = projectInPlane(pc2,modelParameters);

pc3 = pcread(myPlanes{topPlaneID}.pathPoints);%in [mt]; indices begin at 0
modelParameters=[myPlanes{topPlaneID}.unitNormal myPlanes{topPlaneID}.D];
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


%% plot the box
if(plotFlag)
    [x1 y1 z1 ] = computeBoundingPlanev2(myPlanes{side1PlaneID});
    [x2 y2 z2 ] = computeBoundingPlanev2(myPlanes{side2PlaneID});
    figure,
        pcshow(pc1)
        hold on
        pcshow(pc2)
        pcshow(pc3)
        plot3(p0(1),p0(2),p0(3),'*b','LineWidth',3)
        myPlotPlaneContour(myPlanes{topPlaneID})
        surf(x1,y1,z1,'FaceAlpha',0.5)
        surf(x2,y2,z2,'FaceAlpha',0.5)
        camup([0 1 0])
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
        title (['box with parameters (depth height width) = (' num2str(depth) ', ' ...
            num2str(height) ', ' num2str(width) ')'])
end
end

