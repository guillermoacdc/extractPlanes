function pc=fusionFrames(frames,scene,rootPath,maxDistance,refVector,opRange,gridStep)
%FUSIONFRAMES Loads, filter and fusion two point cloud frames, into a
%single frame
%   Detailed explanation goes here

N=size(frames,2);
for i=1:N
    frame=frames(i);
    [pc_mm, T]=loadSLAMoutput(scene,frame,rootPath); 
    cameraPosition=T(1:3,4);
    pc_filtered{i}=filterRawPC(pc_mm,maxDistance,refVector, cameraPosition, opRange);
end

% for i=1:N
    pc = pcmerge(pc_filtered{1},pc_filtered{2},gridStep);
% end

end

