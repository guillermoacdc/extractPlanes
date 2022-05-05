function [pc_cut] = cutLength_Y(pc,geometricCenter,percentage)
%CUTLENGTH_Y Summary of this function goes here
%   Detailed explanation goes here
%   Assumptions: 
% * pc is centered in the origin of q_ref


% % eliminate dc component in pc
% D=repmat(geometricCenter,size(pc.Location,1),1);
% pc = pctransform(pc,-D);%ptcloud centered in origin

% compute tresholds
ymaxTh=percentage*max(pc.Location(:,2));
yminTh=percentage*min(pc.Location(:,2));

% cut the shape using tresholds
pctemp_xyz=[pc.Location(:,1) pc.Location(:,2) pc.Location(:,3)];
for i=1:pc.Count
    if pc.Location(i,2)>ymaxTh || pc.Location(i,2)<yminTh 
        pctemp_xyz(i,:)=[0 0 0];
    end
end
% assembly result in PointCloud object
pc_cut = pointCloud(pctemp_xyz);
end

