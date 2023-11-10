function Lx=computeBoxWidthFromPerpPlane(planeDescriptor)
%COMPUTEBOXWIDTHFROMPERPPLANE Computes the box width (or depth) from a 
% descriptor of a perpendicular plane

if planeDescriptor.L2toY
    Lx=planeDescriptor.L1;
else
    Lx=planeDescriptor.L2;
end

end

