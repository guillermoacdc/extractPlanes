function [pts] = extract2DPoints(planeDescriptor)
%EXTRACT2DPOINTS Compute the four vertices of a rectangle (in 3D space)
%from planeDescriptor
% assumptions: the plane is parallel to a plane x-z
% create the rectangule based on L1, L2 values
%top plane version; with y=0. extended vector
p1=[-planeDescriptor.L2/2 0 planeDescriptor.L1/2 1]';
p2=[planeDescriptor.L2/2 0 planeDescriptor.L1/2 1]';
p3=[planeDescriptor.L2/2 0 -planeDescriptor.L1/2 1]';
p4=[-planeDescriptor.L2/2 0 -planeDescriptor.L1/2 1]';


% apply a transformation on the rectangule; rotation and translation
p1t=planeDescriptor.tform*p1;
p1t=p1t(1:3);

p2t=planeDescriptor.tform*p2;
p2t=p2t(1:3);

p3t=planeDescriptor.tform*p3;
p3t=p3t(1:3);

p4t=planeDescriptor.tform*p4;
p4t=p4t(1:3);

pts=[p1t(1) p1t(3); p2t(1) p2t(3); p3t(1) p3t(3); p4t(1) p4t(3) ];

end

