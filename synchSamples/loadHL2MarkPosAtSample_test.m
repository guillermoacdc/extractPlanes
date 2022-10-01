clc
close all
clear

rootPath="C:\lib\boxTrackinPCs\";
scene=6;
initSample=960*7;
markerIDs=[0 3 4 5 6];

sample=[initSample:initSample+1000];

position = loadHL2MarkPosAtSample(scene,rootPath,sample);


return
markerIDRef=3;

d=computeRefDistances_v2(position,markerIDRef);

% plot results

for i=1:length(markerIDs)
    X(i)=position.(['M00' num2str(markerIDs(i))])(1);
    Y(i)=position.(['M00' num2str(markerIDs(i))])(2);
    Z(i)=position.(['M00' num2str(markerIDs(i))])(3);
end
figure,
    plot3(X,Y,Z)
    hold on
    plot3(X(2),Y(2),Z(2),'ro')
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    grid on
    axis tight
    title (['markers in space - scene/sample ' num2str(scene) '/' num2str(sample)])
