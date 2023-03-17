% function [et,er, et_xyz, alpha, beta, gamma] = computeSinglePoseError(T1,T2)
function [et,er] = computeSinglePoseError(T1,T2)
%COMPUTESINGLEPOSEERROR Computes translation and rotation errors from
%estimated and reference matrices with pose of an object.The output is
% computed using (index1 - index2) sequence. 
%   Detailed explanation goes here

% index 1 is used for estimated variable
% index 2 is used for reference variable
% er is returned in degrees
% et is returned in length unities



t2=T2(1:3,4);%in mm
R2=T2(1:3,1:3);%in rads or in degrees

t1=T1(1:3,4);%in mm
R1=T1(1:3,1:3);%in rads or in degrees


et=norm(t1-t2);
er=acos((trace(R1'*R2)-1)/2)*180/pi;
er=real(er);%indagate what about the imaginary part

% et_xyz=abs(t1-t2); %translation error at each axis
% 
% 
% R=myRotationSolver(R1,R2);
% % conversion from roation matrix to euler angles
% eul=rotm2eul(R);%returns Euler rotation angles in radians
% % sort output angles by sequence x, y, z, and convert to degrees
% alpha=eul(3)*180/pi;
% beta=eul(2)*180/pi;
% gamma=eul(1)*180/pi;
end

