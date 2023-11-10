function height = computeBoxHeightFromPerpPlane(planeDescriptor)
%COMPUTEBOXHEIGHTFROMPERPPLANE Computes box height from a descriptor of a
%perpendicular plane

if planeDescriptor.L2toY
    height=planeDescriptor.L2;
else
    height=planeDescriptor.L1;
end
end

