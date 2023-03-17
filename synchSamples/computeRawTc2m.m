% computes a raw version of Tc2m
clc
close all
clear

rootPath="G:\Mi unidad\boxesDatabaseSample\";
scene=5;
% load common frames
[tm, th]=loadCommonFrames(rootPath,scene);
samplesHL2=loadAvailableFramesFromHL2(rootPath,scene);
fsm=960;
% compute sampling frequency of HL2 device
fsh=computeSamplingFreq(rootPath,scene);
tm_ref=round(fsm/fsh)*th;

if (tm>tm_ref)
    disp('case 2: mocap begins scanning before HL2')
    offset=tm-tm_ref;
%     offset=47552083;
    synchSamplesMocap=round(fsm/fsh)*samplesHL2+offset;
else
    disp('case 1: HL2 begins scanning before mocap')
    offset=tm_ref-tm;
    synchSamplesMocap=round(fsm/fsh)*samplesHL2-offset;
end
% eliminate negative samples
synchSamplesMocap=synchSamplesMocap(synchSamplesMocap>0);
% eliminate samples higher than maximum frame in mocap
    fileName_mf=[rootPath+'corrida'+num2str(scene)+'\mocap\initialPose1.csv'];
    mocapFrames_t=csvread(fileName_mf);
    maxmocapFrames=mocapFrames_t(1,2);
synchSamplesMocap=synchSamplesMocap(synchSamplesMocap<maxmocapFrames);    

Tc2m=computeTm_c(scene,synchSamplesMocap,rootPath);
% write result to txt file
fileName = ['rig2Mocap_offset'  num2str(offset)  '.txt'];
fullFilePath=rootPath + 'corrida' + num2str(scene) + '\' + fileName;
fid = fopen( fullFilePath, 'wt' );%object to write a txt file
for i=1:length(synchSamplesMocap)
    fid= myWriteToFile_v2( Tc2m(i,:), synchSamplesMocap(i), fid);
end
fclose(fid);