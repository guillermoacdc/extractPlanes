clc 
close all
clear


index=1;
xmin=-1000;
xmax=3000;
ymin=-2000;
ymax=2000;
step=10;
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
% fuse the groudn with the model
figure,
% pcshow(pc_woutGround,"MarkerSize",10)
% hold on
% pcshow(pcmodel)
pcshow(pcGround)

xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
% title (['pc from scene/frame ' num2str(scene) '/' num2str(frame)])
