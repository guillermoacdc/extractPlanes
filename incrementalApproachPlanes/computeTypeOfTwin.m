function type = computeTypeOfTwin(localPlane,globalPlane, tao, theta)
%COMPUTETYPEOFTWIN Summary of this function goes here
%   Detailed explanation goes here
% parameters
% dgc_1=0.02;
dgc_2=compute_gc2(localPlane,globalPlane);
L2max=max(localPlane.L2,globalPlane.L2);
dgc_3=0.25*L2max;

% IoU_1=0.75;
Amin=min(localPlane.L1*localPlane.L2,globalPlane.L1*globalPlane.L2);
Amax=max(localPlane.L1*localPlane.L2,globalPlane.L1*globalPlane.L2);
IoU_2=Amin/Amax;
IoU_3=0.3;

angle_L1_ref=5;

bandSLAM_d1=0.02;%length
bandSLAM_d2=0.03;%length
bandSLAM_A=0.05;%percentage or adimensional
bandSLAM_a=3;%angle

% measurements
d=measureGeomCenterBtwnPlanes(localPlane,globalPlane);
IoU=measureIoUbtwnPlanes(localPlane,globalPlane);
angleL1=measureAngleBtwnL1Lines_v2(localPlane,globalPlane);
% angleL2=measureAngleBtwnL2Lines(localPlane,globalPlane);
topOccludedL=localPlane.topOccludedPlaneFlag;
topOccludedG=globalPlane.topOccludedPlaneFlag;
if isempty(topOccludedG)
    topOccludedG=false;
end

if isempty(topOccludedL)
    topOccludedL=false;
end
% analysis
type=0;

% c1  =   (d>=0 & d<=(dgc_1+bandSLAM_d1)) & ...
%     (IoU>=IoU_1) & ...
%     (angleL1<=(angle_L1_ref+bandSLAM_a));

% tao=50/1000;%in meters----50mm
% theta=0.5;%in percentage
eADD=compute_eADDTwins(localPlane,globalPlane,tao);
if eADD<theta 
    c1=true;
else
    c1=false;
end

c2= (IoU>=IoU_2-bandSLAM_A & IoU<=IoU_2) & ...
    (d>=dgc_2-bandSLAM_d2 & d<=dgc_2+bandSLAM_d2) & ...
    (angleL1<=angle_L1_ref+bandSLAM_a);

c3= (d>=(dgc_3-bandSLAM_d1) & d<=(dgc_3+bandSLAM_d1))& ...
    IoU>=IoU_3 &...
    xor( topOccludedL , topOccludedG );


if c1
    type=1;
else
    if c2
        type=2;
    else
        if c3
            type=3;
        end
    end
end

end

