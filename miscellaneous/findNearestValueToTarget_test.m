clc
close all
clear

spatialSampling=10;
xmin=-20;
xmax=20;
ymin=-10;
ymax=30;
pc_grid=createSyntheticGround(xmax, xmin, ymax, ymin, spatialSampling);
grid2D=pc_grid.Location(:,[1 2]);
xyRemove=[10 -10; 10 0;10 10;10 20 ];
N=size(xyRemove,1);
index=zeros(N,1);
for i=1:N
    target=xyRemove(i,:);
    idx = findNearestValueToTarget(target,grid2D);
    index(i)=idx;
end



% 
    