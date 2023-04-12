

% color the ground truth point cloud with green color [0 1 0]
pointscolor=uint8(zeros(pc_gt.Count,3));
pointscolor(:,1)=0;
pointscolor(:,2)=255;
pointscolor(:,3)=0;
pc_gt.Color=pointscolor;
% color the estimated point cloud with white color [1 1 1]. For more colors visit: https://www.mathworks.com/help/matlab/creating_plots/specify-plot-colors.html
pointscolor=uint8(zeros(pc_estimated.Count,3));
pointscolor(:,1)=255;
pointscolor(:,2)=255;
pointscolor(:,3)=255;
pc_estimated.Color=pointscolor;


figure,
pcshow(pc_gt)
hold
pcshow(pc_estimated, "MarkerSize", 10)
% dibujarsistemaref(Te,'e',120,2,10,'w')
% dibujarsistemaref(T_gt,boxID,120,2,10,'w')
title (['Synthetic pcs. Estimated in white. GT in green. e_{ADD}= ' num2str(e) ' for tao= ' num2str(tao)])
grid