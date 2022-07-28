function distance = computeDistanceToCamera_indexWise(myPlanes,ID, baseFrame)
%COMPUTEDISTANCETOCAMERA_indexWise Compute the distance between the geometric center 
% of a plane with identifier ID and the camera that mapped that plane
% inputs
% Assumptions: 
% myPlanes
% identifier ID: bidimensional; 
% Update 1. ----Handle vectors of IDs with size Nx2
% * load the data based on the index i, but not the element
N=size(ID, 1);
distance=zeros(N,1);
for i=1:N
%     frame=ID(i,1);
%     element=ID(i,2);
    cpos=myPlanes.(['fr' num2str(baseFrame)]).cameraPose(1:3,4);
    ppos=myPlanes.(['fr' num2str(baseFrame)]).values(i).tform(1:3,4);
    distance(i)=norm(cpos-ppos);
end


%   Detailed explanation goes here
% frame=ID(1);
% element=ID(2);
% cpos=myPlanes.(['fr' num2str(frame)]).cameraPose(1:3,4);
% ppos=myPlanes.(['fr' num2str(frame)]).values(element).tform(1:3,4);
% distance=norm(cpos-ppos);
end

