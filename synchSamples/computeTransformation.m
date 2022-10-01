function [Thl2] = computeTransformation(interpolatedMarkers, rPlane, aPlane, tform, VLC_HL2)
%COMPUTETRANSFORMATION Summary of this function goes here
%   Detailed explanation goes here

%% project the points l06half and l4 to the transformed plane 
% l06half process
    nx=(interpolatedMarkers(1,5)-(interpolatedMarkers(1,5)-interpolatedMarkers(1,1))/2);
    ny=(interpolatedMarkers(2,5)-(interpolatedMarkers(2,5)-interpolatedMarkers(2,1))/2);
    nz=(interpolatedMarkers(3,5)-(interpolatedMarkers(3,5)-interpolatedMarkers(3,1))/2);    
    l06half=[nx ny nz]';
    l06half_p=projectInPlane(l06half, rPlane.Parameters, tform);

% l4 process    
    l4_p=projectInPlane(interpolatedMarkers(:,3),rPlane.Parameters,tform);
    
%% recopilaci√≥n de vectores paralelos a sistema de ref hl2
% paralelo a x
xx=aPlane(1:3);
% paralelo a z
zz=l4_p-l06half_p;
zz=zz/norm(zz);%normalizaci√≥n de z
% paralelo a y
yy=cross(xx,zz);
% Pendent: find a general formulation for this
yy=-yy;%it was necessary to comply the right hand rule between axes. 

% assembly of T
Thl2=eye(4);
r11=dot(xx,[1 0 0]);
r21=dot(xx,[0 1 0]);
r31=dot(xx,[0 0 1]);

r12=dot(yy,[1 0 0]);
r22=dot(yy,[0 1 0]);
r32=dot(yy,[0 0 1]);

r13=dot(zz,[1 0 0]);
r23=dot(zz,[0 1 0]);
r33=dot(zz,[0 0 1]);

Thl2(1:3,1:3)=[r11 r12 r13; r21 r22 r23; r31 r32 r33];
Thl2(1:3,4) =   interpolatedMarkers(:,5);% first distance vector 
% c·lculo de vector de traslaciÛn
 
 VLC_mocap=Thl2*VLC_HL2;
 Thl2(:,4) =   VLC_mocap;% second distance vector 
 
end

