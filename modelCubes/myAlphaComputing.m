function [alpha] = myAlphaComputing(pc, planeDescriptor)
%MYALPHACOMPUTING Summary of this function goes here
%   Detailed explanation goes here


[pa_max pb_max] = computeFartherPoint(planeDescriptor.geometricCenter',pc, [1 0 0]', [0 0 1]');
theta1=atan2(pb_max,pa_max)*180/pi;
theta2=atan2(pa_max,pb_max)*180/pi;
T=eye(4);
T(1:3,4)=planeDescriptor.geometricCenter';

if(theta1<theta2)
    alpha=theta1;
else
    alpha=-theta2;
end

% alpha=min(theta1,theta2);
% alpha=max(theta1,theta2);
T2=T;
T2(1:3,1:3)=roty(alpha);

figure,
	pcshow(pc)
    hold on 
    dibujarsistemaref (T,0,1,1)%ref
    dibujarsistemaref (T2,1,0.5,1)%rotated
	xlabel 'x'
	ylabel 'y'
	zlabel 'z'
    title (['plane ID:' num2str(planeDescriptor.idPlane)  ' tilt: ' num2str(planeDescriptor.planeTilt)  ' \theta_1 : ' num2str(theta1) ' \theta_2 : ' num2str(theta2) ' antiparallel normal: ' num2str(planeDescriptor.antiparallelFlag) ])

end

