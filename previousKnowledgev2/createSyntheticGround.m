function [pcGround, groundPoints] = createSyntheticGround(xmax, xmin, ymax, ymin, step)
%CREATESYNTHETICGROUND Summary of this function goes here
%   Detailed explanation goes here

index=1;
% xmin=-1000;
% xmax=3000;
% ymin=-2000;
% ymax=2000;
% step=10;
xvector=[xmin:step:xmax];
yvector=[ymin:step:ymax];
N=length(xvector)*length(yvector);
groundPoints=zeros(N,3);
for i=xmin:step:xmax%x
    for j=ymin:step:ymax
        groundPoints(index,:)=[i j 0];
        index=index+1;
    end
end
pcGround=pointCloud(groundPoints);

end

