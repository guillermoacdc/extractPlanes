function [alpha] = myAlphaComputingv2(pc, planeDescriptor, plotFlag)
%MYALPHACOMPUTING Summary of this function goes here
%   Detailed explanation goes here
if(nargin==2)
    plotFlag=0;
end

if (planeDescriptor.planeTilt==1)%xyTilt
    alpha=computeAngleBtwnVectors([0 0 1], planeDescriptor.unitNormal);
else%zyTilt
    alpha=computeAngleBtwnVectors([1 0 0], planeDescriptor.unitNormal);   
end

if(alpha>180)
    alpha=alpha-180;
end

if(mean(pc.Location(:,1))>0)
    alpha=-alpha;
end


T=eye(4);
T(1:3,4)=planeDescriptor.geometricCenter';
T2=T;
T2(1:3,1:3)=roty(alpha);

if(plotFlag)
    figure,
	    pcshow(pc)
        hold on 
        dibujarsistemaref (T,0,1,1)%ref
        dibujarsistemaref (T2,1,0.5,1)%rotated
	    xlabel 'x'
	    ylabel 'y'
	    zlabel 'z'
        title (['plane ID:' num2str(planeDescriptor.idPlane)  ' tilt: ' num2str(planeDescriptor.planeTilt)  ' \alpha : ' num2str(alpha) ' antiparallel normal: ' num2str(planeDescriptor.antiparallelFlag) ])
end


end

