function myPlotPlaneContourPerpend(planeDescriptor, fc)
%MYPLOTPLANECONTOUR Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    fc='b';
end

% create the rectangule based on L1, L2 values
%perpendicular plane version; with zero value at x or z. extended vector

if (planeDescriptor.planeTilt==0)%(planeTilt->0) for (z-y tilt) 
    if planeDescriptor.L2toY==0 %     
        p1=[0   planeDescriptor.L1/2 -planeDescriptor.L2/2         1]';
        p2=[0   planeDescriptor.L1/2 planeDescriptor.L2/2          1]';
        p3=[0   -planeDescriptor.L1/2 planeDescriptor.L2/2         1]';
        p4=[0   -planeDescriptor.L1/2 -planeDescriptor.L2/2        1]';

    else %     L1 parallel to y axis
        p1=[0   planeDescriptor.L2/2    -planeDescriptor.L1/2         1]';
        p2=[0   planeDescriptor.L2/2    planeDescriptor.L1/2          1]';
        p3=[0   -planeDescriptor.L2/2   planeDescriptor.L1/2         1]';
        p4=[0   -planeDescriptor.L2/2   -planeDescriptor.L1/2        1]';

    end
else %(planeTilt->1) for (x-y tilt);
    if planeDescriptor.L2toY==0 %     L2 parallel to y axis
        p1=[-planeDescriptor.L2/2   planeDescriptor.L1/2    0 1]';
        p2=[planeDescriptor.L2/2    planeDescriptor.L1/2    0 1]';
        p3=[planeDescriptor.L2/2    -planeDescriptor.L1/2   0 1]';
        p4=[-planeDescriptor.L2/2   -planeDescriptor.L1/2   0 1]';

    else %     L1 parallel to y axis
        p1=[-planeDescriptor.L1/2   planeDescriptor.L2/2    0 1]';
        p2=[planeDescriptor.L1/2    planeDescriptor.L2/2    0 1]';
        p3=[planeDescriptor.L1/2    -planeDescriptor.L2/2   0 1]';
        p4=[-planeDescriptor.L1/2   -planeDescriptor.L2/2   0 1]';

    end
end

% apply a transformation on the rectangule; rotation and translation
p1t=planeDescriptor.tform*p1;
p1t=p1t(1:3);

p2t=planeDescriptor.tform*p2;
p2t=p2t(1:3);

p3t=planeDescriptor.tform*p3;
p3t=p3t(1:3);

p4t=planeDescriptor.tform*p4;
p4t=p4t(1:3);

% plot the transformed rectangle

dibujarlinea(p1t,p2t,fc,1)
dibujarlinea(p2t,p3t,fc,1)
dibujarlinea(p3t,p4t,fc,1)
dibujarlinea(p4t,p1t,fc,1)

end

