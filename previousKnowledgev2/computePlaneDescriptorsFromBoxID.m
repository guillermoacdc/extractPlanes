function [planeDescriptor] = computePlaneDescriptorsFromBoxID(boxID,sessionID, dataSetPath)
%COMPUTEPLANEDESCRIPTORSFROMBOXID Computes descriptors of the set of planes
%that belong to the box with boxID. Those descriptors are refered to the
%coordinate frame q_b

% load lengths of the box
boxLengths=loadLengths_v2(dataSetPath,boxID);%IdBox,Heigth(mm),Width(mm),Depth(mm)
Height=boxLengths(2);
Width=boxLengths(3);
Depth=boxLengths(4);

%% 1 create descriptor for top plane
tref=[0 0 0];
A=0;
B=0;
C=1;
D=0;

planeD_top=plane(sessionID,0,1,[A B C D tref],[],[]);
T=eye(4);
planeD_top.tform=T;
[L1,L2]=computeL1L2FromPK(boxLengths,0);
planeD_top.L1=L1;
planeD_top.L2=L2;
planeD_top.L2toY=true;
%% 2 create descriptor for front plane

Rref=[0 -1 0; 0 0 1; -1 0 0];
tref=[0 Width/2 -Height/2];
A=0;
B=1;
C=0;
D=-Width/2;

planeD_front=plane(sessionID,0,2,[A B C D tref],[],[]);
T(1:3,1:3)=Rref;
T(1:3,4)=tref;
planeD_front.tform=T;
[L1,L2]=computeL1L2FromPK(boxLengths,1);
planeD_front.L1=L1;
planeD_front.L2=L2;
planeD_front.L2toY=true;
%% 3 create descriptor for back plane

Rref=[0 1 0; 0 0 -1; -1 0 0];
tref=[0 -Width/2 -Height/2];
A=0;
B=-1;
C=0;
D=-Width/2;

planeD_back=plane(sessionID,0,4,[A B C D tref],[],[]);
T(1:3,1:3)=Rref;
T(1:3,4)=tref;
planeD_back.tform=T;
% reuses the previous L1, L2
planeD_back.L1=L1;
planeD_back.L2=L2;
planeD_back.L2toY=true;
%% 4 create descriptor for right plane
% [L1,L2]=computeL1L2FromPK(boxLengths,2);
Rref=[0 0 1; 0 1 0; -1 0 0];
tref=[Depth/2 0 -Height/2];
A=1;
B=0;
C=0;
D=-Depth/2;

planeD_right=plane(sessionID,0,3,[A B C D tref],[],[]);
T(1:3,1:3)=Rref;
T(1:3,4)=tref;
planeD_right.tform=T;
[L1,L2]=computeL1L2FromPK(boxLengths,2);
planeD_right.L1=L1;
planeD_right.L2=L2;
planeD_right.L2toY=true;
%% 5 create descriptor for left plane
Rref=[0 0 -1; 0 -1 0; -1 0 0];
tref=[-Depth/2 0 -Height/2];
A=-1;
B=0;
C=0;
D=-Depth/2;

planeD_left=plane(sessionID,0,5,[A B C D tref],[],[]);
T(1:3,1:3)=Rref;
T(1:3,4)=tref;
planeD_left.tform=T;
% reuses the previous L1, L2
planeD_left.L1=L1;
planeD_left.L2=L2;
planeD_left.L2toY=true;

planeDescriptor=[planeD_top planeD_front planeD_right planeD_back planeD_left];
end

