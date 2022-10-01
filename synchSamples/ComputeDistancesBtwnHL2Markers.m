clc
close all
clear

rootPath="C:\lib\boxTrackinPCs\";
scene=6;
initSample=960*7;
markerIDs=[0 3 4 5 6];
% load number of samples from json file
% endSample=loadNumberSamplesMocap(rootPath,scene);
% sample=[initSample:initSample+1000];
sample=initSample+899;


% load position of markers at sample
position = loadHL2MarkPosAtSample(scene,rootPath,sample);
% compute distance between markers for each sample
for i=1:size(sample,2)
    m0pos=position.M000(i,:);
    m3pos=position.M003(i,:);
    L03(i)=norm(m0pos-m3pos);
end
figure,
plot(L03)
grid

markerIDRef=3;

d=computeRefDistances_v2(position,markerIDRef);

% create a txt output file wit d0, d4, d5, d6
fileName = ['HLMarkersDistance_m3ref.txt'];
fullFilePath=rootPath + 'scene' + num2str(scene) + '\' + fileName;

fid = fopen( fullFilePath, 'wt' );%object to write a txt file
for i=1:size(d,2)
 fprintf( fid, '%f,%f,%f\n',d(:,i)' );
end
fclose(fid);

% plot results
row=1;
for i=1:length(markerIDs)
    X(i)=position.(['M00' num2str(markerIDs(i))])(row,1);
    Y(i)=position.(['M00' num2str(markerIDs(i))])(row,2);
    Z(i)=position.(['M00' num2str(markerIDs(i))])(row,3);
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
%     title (['markers in space - scene/sample ' num2str(scene) '/' num2str(sample)])
