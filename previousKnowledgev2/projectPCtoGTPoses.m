function pcmodel=projectPCtoGTPoses(pcBox, planeDescriptor)
% PROJECTPCTOGTPOSES projects each point of each individual pc in pci to
% their coresponding ground truth pose
% Assumption: the point clouds in pci are described by values in
% planeDescriptor object

% project synthetic point clouds with its own Tform and merge points into a
% single vector
model=[];


Nboxes=length(planeDescriptor.fr0.values);
for i=1:Nboxes
%     indexBox=idxBoxes(i);
    indexBox=i;
    T=planeDescriptor.fr0.values(indexBox).tform;
    pcBox_m=myProjection_v3(pcBox{indexBox},T);
    model=[model; pcBox_m.Location];%merge points into a single vector

end
% remove points with z<0
model_z=model(:,3);
idx=find(model_z<0);
model(idx,:)=[];
% convert merged vector to a point cloud object
pcmodel=pointCloud(model);
end