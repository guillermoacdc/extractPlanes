function [face1 face2 face3] = createBoxPCv4(Width,Depth,Height)
%CREATEBOXPC Create a model of a box in R3 and locates its origin at the
%top of the box, geometric center

%   Detailed explanation goes here
% input.
% 
% H: Height (z)
% W: Width (x)
% D: Depth (y)

% output.
% facex: struct with fields that describes a segmented plane. face 1 and 2
% are perpendicular to ground. face 3 is parallel to ground. i.e. top plane

% f1 = 
% 
%   struct with fields:
%                xmin: -0.9500
%                xmax: 0.9500
%                zmin: -0.6000
%                zmax: 0.6000
%     planeParameters: [0 1 0 0.8000] % [A B C D]
%                   x: [2×2 double]
%                   z: [2×2 double]
%                   y: [2×2 double]

%% convert dimensions into limits of the planes
face1.xmin=-Width/2;
face1.xmax=Width/2;
face1.zmin=-Height/2;
face1.zmax=Height/2;

face2.ymin=-Depth/2;
face2.ymax=Depth/2;
face2.zmin=-Height/2;
face2.zmax=Height/2;

face3.xmin=-Width/2;
face3.xmax=Width/2;
face3.ymin=-Depth/2;
face3.ymax=Depth/2;

%% use plane parameter to create the coordinates of points
face1.planeParameters=[0 1 0 -Depth/2];
face2.planeParameters=[1 0 0 -Width/2];
face3.planeParameters=[0 0 1 -Height/2];



%% return plane model to plot
face1.x=[face1.xmin face1.xmax; face1.xmin face1.xmax];
face1.z=[face1.zmin face1.zmin; face1.zmax face1.zmax];
A=face1.planeParameters(1);
B=face1.planeParameters(2);
C=face1.planeParameters(3);
D=face1.planeParameters(4);
face1.y=-1/B*(A*face1.x + C*face1.z + D);
face1.geometricCenter=[0 Depth/2 0];
%---

face2.y=[face2.ymin face2.ymax; face2.ymin face2.ymax];
face2.z=[face2.zmin face2.zmin; face2.zmax face2.zmax];
A=face2.planeParameters(1);
B=face2.planeParameters(2);
C=face2.planeParameters(3);
D=face2.planeParameters(4);
face2.x=-1/A*(B*face2.y + C*face2.z + D); 
face2.geometricCenter=[Width/2 0 0];
%-----
face3.x=[face3.xmin face3.xmax; face3.xmin face3.xmax];
face3.y=[face3.ymin face3.ymin; face3.ymax face3.ymax];
A=face3.planeParameters(1);
B=face3.planeParameters(2);
C=face3.planeParameters(3);
D=face3.planeParameters(4);
face3.z=-1/C*(A*face3.x + B*face3.y + D);
face3.geometricCenter=[0 0 Height/2];


