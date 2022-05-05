function lengthBounds = loadBoundParameters(scene)
%LOADBOUNDPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    parameters=load(['scene' num2str(scene) 'Planes.txt']);%IDplane, IdBox, L1(cm), L2(cm), normalType
    features=parameters(:,[3:5]);
    L1max=max(features(:,1));
    L2max=max(features(:,2));
    L1min=min(features(:,1));
    L2min=min(features(:,2));
    lengthBounds=[L1min L1max L2min L2max];
end

