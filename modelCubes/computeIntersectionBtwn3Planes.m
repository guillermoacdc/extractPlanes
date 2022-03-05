function p0 = computeIntersectionBtwn3Planes(p1,p2,p3,n1,n2,n3)
%UNTITLED computes the intersectin point between three perpendicular planes
%based on section 4.3 from [1]
% [1] file:///G:/Mi%20unidad/semestre%206/1-3%20AlgoritmosSeguimientoPose/detectorCajas/Incremental-3D-cuboid-modeling-with-drift-compensationSensors-Switzerland.pdf
%   Detailed explanation goes here

% size(px)->[1x3]
% size(nx)->[3x1]

p0=(p1*n1)*cross(n2,n3)/(cross(n1,n2)'*n3) + ...
    (p2*n2)*cross(n3,n1)/(cross(n1,n2)'*n3)+ ...
(p3*n3)*cross(n1,n2)/(cross(n1,n2)'*n3);

end

