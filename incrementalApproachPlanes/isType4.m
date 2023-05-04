function type4 = isType4(planeA,planeB,maxTopSize, th_cd)
%ISTYPE4 Evaluates the existence of conditions to satisfy type4 pair of
%planes
%   Detailed explanation goes here
% th_cd=12;%mm dispersión entre puntos que perenecen al mismo plano, a lo largo de la normal del plano

type4=0;
[distanceBtwnGC, coplanarDistance]=computeDistanceBtwnPlanes(planeA,planeB);
if distanceBtwnGC>0.8*maxTopSize
    return
end

IoU = measureIoUbtwnPlanes(planeA,planeB);
if coplanarDistance<th_cd & IoU > 0
    type4=1;
end

end

