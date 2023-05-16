function [backPlane, frontPlane, leftPlane, rigthPlane] = computeLateralPlanesPose(topPlane, ...
    boxLengths, sessionID)
%COMPUTELATERALPLANESPOSE Summary of this function goes here
%   Detailed explanation goes here
height=boxLengths(2);
%% compute frontplane and backplane 
frontPlane_t=[0 topPlane.L2/2 -height/2];
backPlane_t=[0 -topPlane.L2/2 -height/2];
frontPlane=plane(sessionID,0,1,[0 1 0 topPlane.L2/2 frontPlane_t],[],[]);
frontPlane.idBox=boxLengths(1);
frontPlane.type=1;
backPlane=plane(sessionID,0,2,[0 -1 0 topPlane.L2/2 backPlane_t],[],[]);
backPlane.idBox=boxLengths(1);
backPlane.type=1;

[L1, L2] =computePlaneLengthsFromGTBox(boxLengths(2:4),1);
frontPlane.L1=L1;
frontPlane.L2=L2;
frontPlane.tform=eye(4);
frontPlane.tform(1:3,4)=frontPlane_t';

backPlane.L1=L1;
backPlane.L2=L2;
backPlane.tform=eye(4);
backPlane.tform(1:3,4)=backPlane_t';

if L1==height
% compute backplane
    backPlane.L2toY=true;
    backPlane.tform(1:3,1:3)=[1 0 0; 0 0 -1; 0 1 0];
% compute frontplane    
    frontPlane.L2toY=true;
    frontPlane.tform(1:3,1:3)=[-1 0 0;0 0 1; 0 1 0];
else
% compute backplane
    backPlane.L2toY=false;
    backPlane.tform(1:3,1:3)=[0 -1 0; 0 0 -1; 1 0 0];
% compute frontplane    
    frontPlane.L2toY=false;
    frontPlane.tform(1:3,1:3)=[0 -1 0;0 0 1; -1 0 0];    
end

%% compute rigthPlane and leftPlane
rigthPlane_t=[topPlane.L1/2 0 -height/2];
leftPlane_t=[-topPlane.L1/2 0 -height/2];
rigthPlane=plane(sessionID,0,4,[1 0 0 topPlane.L1/2 rigthPlane_t],[],[]);
rigthPlane.idBox=height(1);
rigthPlane.type=1;
leftPlane=plane(sessionID,0,3,[-1 0 0 -topPlane.L1/2 leftPlane_t],[],[]);
leftPlane.idBox=height(1);
leftPlane.type=1;
[L1, L2] = computePlaneLengthsFromGTBox(boxLengths(2:4),2);

rigthPlane.L1=L1;
rigthPlane.L2=L2;
rigthPlane.tform=eye(4);
rigthPlane.tform(1:3,4)=rigthPlane_t';
leftPlane.L1=L1;
leftPlane.L2=L2;
leftPlane.tform=eye(4);
leftPlane.tform(1:3,4)=leftPlane_t';
if L1==height
% compute rigthPlane
    rigthPlane.L2toY=true;
    rigthPlane.tform(1:3,1:3)=[-1 0 0; 0 0 -1; 0 1 0];
% compute leftPlane    
    leftPlane.L2toY=true;
    leftPlane.tform(1:3,1:3)=[0 0 -1;0 1 0; 1 0 0];
else
% compute rigthPlane
    rigthPlane.L2toY=false;
    rigthPlane.tform(1:3,1:3)=[0 -1 0; 0 0 -1; -1 0 0];
% compute leftPlane    
    leftPlane.L2toY=false;
    leftPlane.tform(1:3,1:3)=[0 0 -1; 1 0 0; 0 -1 0];    
end

%% project planes with q_boxID


end

