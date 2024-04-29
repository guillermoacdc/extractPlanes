function [e] = computeSingle_eADI(pc_gt,pc_estimated,  tao)

%COMPUTESINGLE_EADI  computes average distance btwn points that belong to a (1) ground
%truth and a (2) estimated point cloud. Assumptions
% 1. all the points are visible. 
% 2. each pc has the same number of points
% Reference in equation (3) of (Hodan et al., 2016)
%  On Evaluation of 6D Object Pose Estimation. <i>Computer Vision – ECCV 
% 2016 Workshops. ECCV 2016. Lecture Notes in Computer Science</i>. 
% https://link.springer.com/chapter/10.1007/978-3-319-49409-8_52</div>
% 
% Note.
% consider break the point to point comparision if the N first
% correspondecnes are at a distance bigger than a treshold. This would
% reduce the computational complexity

%   Detailed explanation goes here
% diff_points=norm(pc_gt.Location-pc_estimated.Location);



%corresponding points comparison
[~, dist]= compute_eADI(pc_gt,pc_estimated);
eADI_a=dist>tao;
e=mean(eADI_a);

end




