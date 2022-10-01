function [tform] = computeT_rotArbitrayAxis(p0, p1, theta)
%COMPUTET_ROTARBITRAYAXIS Summary of this function goes here
%   Detailed explanation goes here
% source at https://www.engr.uvic.ca/~mech410/lectures/4_2_RotateArbi.pdf
% theta in radians
% 

% compute constants
A=p1(1)-p0(1);
B=p1(2)-p0(2);
C=p1(3)-p0(3);
L=norm([A B C]);
V=sqrt(B^2+C^2);

% translate arbitray axis to origin
D=eye(4);
D(1:3,4)=-p0;

% rotate about x axis
Rx=eye(4);
Rx(2:3,2:3)=[C/V -B/V; B/V C/V];

% rotate about y axis
Ry=eye(4);
Ry(1,1)=V/L;
Ry(1,3)=-A/L;
Ry(3,1)=A/L;
Ry(3,3)=V/L;

% rotate theta degrees positive
Rz=eye(4);
Rz(1:2,1:2)=[cos(theta) -sin(theta); sin(theta) cos(theta)];

% reverse Ry
Ry_1=eye(4);
Ry_1(1,1)=V/L;
Ry_1(1,3)=A/L;
Ry_1(3,1)=-A/L;
Ry_1(3,3)=V/L;

% reverse Rx
Rx_1=eye(4);
Rx_1(2:3,2:3)=[C/V B/V; -B/V C/V];

% reverse the translation
D_1=eye(4);
D_1(1:3,4)=p0;

% calculate the total transformation
tform=D_1*Rx_1*Ry_1*Rz*Ry*Rx*D;

end

% bugs
% does not work when componentes x, z of p0 and p1 are equal. This
% provocates a V=0. Then, an indetermintaion in the Rx_1 matrix

