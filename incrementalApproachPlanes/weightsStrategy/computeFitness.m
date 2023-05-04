function fitness = computeFitness(planeDescriptor)
%COMPUTEFITNESS Computes the fitness of a plane object assuming that
%the best fitness is related with:
% (a) objects where the distance to camera is in the range [th_dmin th_dmax].
% The distance thresholds depends on the sensor, for HL2/depth camera I 
% suggest: th_dmin=1.5 m, th_dmax=2.5 m 
% (b) Angle between the axis z in camera and the normal of the plane is 
% near to 0 or 180 
% (c) the distance and orientation is kept between adjacent frames. This
% property is measured in the deltaCameraPose variable
% deltaPoseCamera=1;
th_dmin=1500;%mm
th_dmax=2500;%mm

dco=planeDescriptor.distanceToCamera;
theta=planeDescriptor.angleBtwn_zc_unitNormal;
% compute inrange  flag
dcoinrange=false;
if dco<th_dmax & dco>th_dmin
    dcoinrange=true;
end
% compute fitness
if dcoinrange
    if theta<90
        fitness=1-theta/90;
    else
        fitness=theta/90-1;
    end
else
    fitness=0;
end
% add the delta camera pose to the fitnness
% fitness=(1-deltaPoseCamera)*fitness;


end

