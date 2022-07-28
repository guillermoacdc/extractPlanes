function plane2D = projectPlaneSegTo2D(L1, L2, L2toY)
%PROJECTPLANESEGTO2D Projects a characterized plane segment from 3D to D.
%The projection is limted to the four corners of the plane. The returned
%points assume that the geometric center of the 2D plane is on the origin
%of the 2 frame
%   Detailed explanation goes here
if  L2toY
    plane2D.p1=[-L1/2 L2/2];
    plane2D.p2=[L1/2 L2/2];
    plane2D.p3=[L1/2 -L2/2];
    plane2D.p4=[-L1/2 -L2/2];
else
    plane2D.p1=[-L2/2 L1/2];
    plane2D.p2=[L2/2 L1/2];
    plane2D.p3=[L2/2 -L1/2];
    plane2D.p4=[-L2/2 -L1/2];
end

end

