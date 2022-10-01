function [et,er, et_xyz] = computeSinglePoseError(Testimated,Treference)
%COMPUTESINGLEPOSEERROR Summary of this function goes here
%   Detailed explanation goes here

% index 1 is used for estimated variable
% index 2 is used for reference variable
% er is returned in degrees
% et is returned in length unities



t2=Treference(1:3,4);%in mm
R2=Treference(1:3,1:3);%in rads or in degrees

t1=Testimated(1:3,4);%in mm
R1=Testimated(1:3,1:3);%in rads or in degrees


et=norm(t1-t2);
er=acos((trace(R1'*R2)-1)/2)*180/pi;

et_xyz=abs(t1-t2); %translation error at each axis
end

