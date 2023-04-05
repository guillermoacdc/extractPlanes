function nearestDescriptor=computeNearestDescriptor(localDescriptor, globalDescriptor)
%COMPUTEL1L2_TWINS Returns the descriptor with lower distance to camera
%   Detailed explanation goes here


if (localDescriptor.distanceToCamera<globalDescriptor.distanceToCamera)
    nearestDescriptor=localDescriptor;
else
    nearestDescriptor=globalDescriptor;
end

end

