function [planeType] = computeNormalType(A, B, C, D, myTolerance)
%COMPUTENORMALTYPE compute the type of normal  by comparing with the normal
%of the ground
%   Detailed explanation goes here
myTol=myTolerance*pi/180;
% compute angle between normal of plane and normal of ground
alpha=computeAngleBtwnVectors([A B C],[0 1 0]);
% alpha=computeAngleBtwnVectors([A B C],[0 0 1]);



if( abs(cos(alpha*pi/180)) > cos (myTol))%con abs también va a aceptar antiparalelos
    planeType=0;%parallel to ground plane
elseif (abs(cos(alpha*pi/180))< cos (pi/2-myTol) )%perpendicular to ground plane
    planeType=1;%perpendicular to ground plane
else%non expected plane
    planeType=2;
end
