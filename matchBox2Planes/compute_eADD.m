function [e] = compute_eADD(pc_gt,pc_estimated, eR, tao, L2)
%COMPUTE_EADD compute average distance btwn points that belong to a (1) ground
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
if nargin==3
    tao=80;%mm
end

N=pc_gt.Count;
eADD_a=zeros(N,1);
diff_points_a=zeros(N,1);
%corresponding points comparison
for i=1:N
    if eR<90
        diff_points_a(i)=norm(pc_gt.Location(i,:)-pc_estimated.Location(i,:));%non inverted
    else
        diff_points_a(i)=norm(pc_gt.Location(i,:)-pc_estimated.Location(N-i+1,:));%inverted
    end

    if diff_points_a(i)>L2*tao/100% comparison between millimeters
        eADD_a(i)=1;
    end
end

e=mean(eADD_a);

% e=mean(diff_points)/pc_gt.Count;%normalized wrt the number of points in the point cloud
end

