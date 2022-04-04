function myPlotPlaneContourPerpend(planeDescriptor)
%MYPLOTPLANECONTOUR Summary of this function goes here
%   Detailed explanation goes here

% create the rectangule based on L1, L2 values
%perpendicular plane version; with zero value at x or z. extended vector

if (planeDescriptor.planeTilt==1)% (0, 1) for (z-y tilt, x-y tilt); non defined for parallel planes
    if planeDescriptor.rotatePlot==0 %L2 along y axis
        p1=[0   -planeDescriptor.L1/2     planeDescriptor.L2/2    1]';
        p2=[0   planeDescriptor.L1/2      planeDescriptor.L2/2    1]';
        p3=[0   planeDescriptor.L1/2      -planeDescriptor.L2/2   1]';
        p4=[0   -planeDescriptor.L1/2     -planeDescriptor.L2/2   1]';
    else % L1 along y axis
        p1=[0   -planeDescriptor.L2/2     planeDescriptor.L1/2    1]';
        p2=[0   planeDescriptor.L2/2      planeDescriptor.L1/2    1]';
        p3=[0   planeDescriptor.L2/2      -planeDescriptor.L1/2   1]';
        p4=[0   -planeDescriptor.L2/2     -planeDescriptor.L1/2   1]';
    end


else %(0, 1) for (z-y tilt, x-y tilt); non defined for parallel planes
    if planeDescriptor.rotatePlot==1 %L1 along y axis
        p1=[-planeDescriptor.L2/2   planeDescriptor.L1/2    0 1]';
        p2=[planeDescriptor.L2/2    planeDescriptor.L1/2    0 1]';
        p3=[planeDescriptor.L2/2    -planeDescriptor.L1/2   0 1]';
        p4=[-planeDescriptor.L2/2   -planeDescriptor.L1/2   0 1]';
    else %     L2 along y axis
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

dibujarlinea(p2t,p1t,'b',1)
dibujarlinea(p3t,p2t,'b',1)
dibujarlinea(p4t,p3t,'b',1)
dibujarlinea(p1t,p4t,'b',1)

end

