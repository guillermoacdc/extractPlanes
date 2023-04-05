function [L1, L2]=computeL1L2_twins(localDescriptor, globalDescriptor)
%COMPUTEL1L2_TWINS Computes L1 and L2 of the plane with lower
%distanceToCamera 
%   Detailed explanation goes here


if (localDescriptor.distanceToCamera<globalDescriptor.distanceToCamera)
    L1=localDescriptor.L1;
    L2=localDescriptor.L2;
else
    L1=globalDescriptor.L1;
    L2=globalDescriptor.L2;
end

end

