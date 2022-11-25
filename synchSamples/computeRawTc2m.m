% computes a raw version of Tc2m
clc
close all
clear

rootPath="G:\Mi unidad\boxesDatabaseSample\";
scene=5;
% load common frames
[tm, th]=loadCommonFrames(rootPath,scene);
samplesHL2=loadAvailableFramesFromHL2(rootPath,scene);
tm_ref=240*th;

if (tm>tm_ref)
    disp('case 2: mocap begins scanning before HL2')
    offset=tm-tm_ref;
    synchSamplesMocap=240*samplesHL2+offset;
else
    disp('case 1: HL2 begins scanning before mocap')
    offset=tm_ref-tm;
    synchSamplesMocap=240*samplesHL2-offset;
end

Tc2m=computeTm_c(scene,synchSamplesMocap,rootPath);
% write result to txt file
fileName = ['rig2Mocap_offset'  num2str(offset)  '.txt'];
fullFilePath=rootPath + 'corrida' + num2str(scene) + '\' + fileName;
fid = fopen( fullFilePath, 'wt' );%object to write a txt file
for i=1:length(synchSamplesMocap)
    fid= myWriteToFile_v2( Tc2m(i,:), synchSamplesMocap(i), fid);
end
fclose(fid);