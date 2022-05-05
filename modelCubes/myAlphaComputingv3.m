function [alpha] = myAlphaComputing_v3(pc, planeDescriptor)
%MYALPHACOMPUTING Summary of this function goes here
%   Detailed explanation goes here


[xL zL] = computeFartherPoint(planeDescriptor.geometricCenter',pc, [1 0 0]', [0 0 1]');

% eliminate dc component in pc
D=repmat(planeDescriptor.geometricCenter,size(pc.Location,1),1);
pc = pctransform(pc,-D);%ptcloud centered in origin


if(planeDescriptor.planeTilt==0)
    alpha=atan2(xL,zL)*180/pi;
    if mean(pc.Location(:,1))<0
        alpha=-alpha;
    end
else
    alpha=atan2(zL,xL)*180/pi;
    if mean(pc.Location(:,3))>0
        alpha=-alpha;
    end
end


T=eye(4);
% T(1:3,4)=planeDescriptor.geometricCenter';

T2=T;
T2(1:3,1:3)=roty(-alpha);%invert alpha to plot the allignment of frame with plane

figure,
	pcshow(pc)
    hold on 
    dibujarsistemaref (T,0,1,1)%ref
    dibujarsistemaref (T2,1,0.5,1)%rotated
	xlabel 'x'
	ylabel 'y'
	zlabel 'z'
    title (['plane ID:' num2str(planeDescriptor.idPlane)  ' tilt: ' num2str(planeDescriptor.planeTilt)  ' \alpha : ' num2str(alpha)  ' antiparallel normal: ' num2str(planeDescriptor.antiparallelFlag) ])

end

