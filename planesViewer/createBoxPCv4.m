function [face1 face2 face3] = createBoxPCv4(W,D,H)
%CREATEBOXPC Create a model of a box in R3 and locates its origin at the
%top of the box, geometric center

%   Detailed explanation goes here
% input.
% 
% H: Height
% W: Width
% D: Depth 

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
face1.xmin=-W/2;
face1.xmax=W/2;
face1.zmin=-H/2;
face1.zmax=H/2;

face2.ymin=-D/2;
face2.ymax=D/2;
face2.zmin=-H/2;
face2.zmax=H/2;

face3.xmin=-W/2;
face3.xmax=W/2;
face3.ymin=-D/2;
face3.ymax=D/2;

%% use plane parameter to create the coordinates of points
face1.planeParameters=[0 1 0 D/2];
face2.planeParameters=[1 0 0 W/2];
face3.planeParameters=[0 0 1 -H/2];



%% return plane model to plot
face1.x=[face1.xmin face1.xmax; face1.xmin face1.xmax];
face1.z=[face1.zmin face1.zmin; face1.zmax face1.zmax];
A=face1.planeParameters(1);
B=face1.planeParameters(2);
C=face1.planeParameters(3);
D=face1.planeParameters(4);
face1.y=-1/B*(A*face1.x + C*face1.z + D);
%---

face2.y=[face2.ymin face2.ymax; face2.ymin face2.ymax];
face2.z=[face2.zmin face2.zmin; face2.zmax face2.zmax];
A=face2.planeParameters(1);
B=face2.planeParameters(2);
C=face2.planeParameters(3);
D=face2.planeParameters(4);
face2.x=-1/A*(B*face2.y + C*face2.z + D);    
%-----
face3.x=[face3.xmin face3.xmax; face3.xmin face3.xmax];
face3.y=[face3.ymin face3.ymin; face3.ymax face3.ymax];
A=face3.planeParameters(1);
B=face3.planeParameters(2);
C=face3.planeParameters(3);
D=face3.planeParameters(4);
face3.z=-1/C*(A*face3.x + B*face3.y + D);



