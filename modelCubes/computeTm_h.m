function Tm_h = computeTm_h(rootPath,scene, frame)
%COMPUTETM_H Computes transformation matrix between hololens world and
%mocap world. 
%   Returns distances in mm and angles in degrees

% load Th_c from Depth Long Throw_rig2world.txt 
Th_c=loadInitialPoseHL2FromHL2(rootPath,scene, frame);%(mm,deg)
% load Tm_c from rig2mocap_1fps.txt 
Tm_c=loadInitialPoseHL2(rootPath,scene, frame);%(mm,deg)
% perform computation
Tm_h=Tm_c*inv(Th_c);

end

