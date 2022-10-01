clc
close all
clear 
rootPath="C:\lib\boxTrackinPCs\";
scene=5;
    % tform is available in the file rootPath/scenex/Mocap_initialPoseBoxes.csv 
    fileName=rootPath  + 'scene' + num2str(scene) + '\corrida5-001.csv';
    mocapDescriptors= readtable(fileName);
%     initialPosesA = table2array(mocapDescriptors);

M0 = groupfilter(mocapDescriptors,'id',@(y) all(y == 0),'id');

xyz=[M0.pos_x M0.pos_y M0.pos_z];
pc=pointCloud(xyz)

figure,
    pcshow(pc)
    grid on
    xlabel x
    ylabel y
    zlabel z

