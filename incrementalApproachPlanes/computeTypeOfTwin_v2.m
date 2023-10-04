function type = computeTypeOfTwin_v2(localPlane,globalPlane,...
    tao, theta, lengthBoundsTop, lengthBoundsP, th_cd)
%COMPUTETYPEOFTWIN Summary of this function goes here
%   Detailed explanation goes here
% parameters
% dgc_1=0.02;
% type      Description
% 0         No twins
% 1         Non-occluded twins
% 2         Twins with merged superficies
% 3         With partial occlusion
% 4         Twins that require creation of derived point cloud

% th_cd: dispersión entre puntos que perenecen al mismo plano, a lo largo de la normal del plano

% if localPlane.idFrame==26 & localPlane.idPlane==5 & ...
%         globalPlane.idFrame==25 & globalPlane.idPlane==2
%     disp("stop the code")
% end

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
DistanceBtwnGC=measureGeomCenterBtwnPlanes(localPlane,globalPlane);
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

eADD=compute_eADDTwins(localPlane,globalPlane,tao);
if eADD<theta 
    c1=true;
else
    c1=false;
end

c2= (IoU>=IoU_2-bandSLAM_A & IoU<=IoU_2) & ...
    (DistanceBtwnGC>=dgc_2-bandSLAM_d2 & DistanceBtwnGC<=dgc_2+bandSLAM_d2) & ...
    (angleL1<=angle_L1_ref+bandSLAM_a);

c3= (DistanceBtwnGC>=(dgc_3-bandSLAM_d1) & DistanceBtwnGC<=(dgc_3+bandSLAM_d1))& ...
    IoU>=IoU_3 &...
    xor( topOccludedL , topOccludedG );

    if(localPlane.type==0)
        maxTopSize=sqrt(lengthBoundsTop(1)^2+lengthBoundsTop(2)^2);%update 
    else
        maxTopSize=sqrt(lengthBoundsP(1)^2+lengthBoundsP(2)^2);%update 
    end


if c1
    type=1;
else
    if c2
        type=2;
    else
        if c3
            type=3;
        else
            if isType4(localPlane,globalPlane,maxTopSize, th_cd)
                type=4;
            end
        end
    end
end

% if type~=0
%     display('stop mark')
% end

end

