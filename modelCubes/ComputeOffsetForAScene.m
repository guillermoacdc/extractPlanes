% Computes the offset time between two cameras: mocap, HL2. Assumptions
% (1) there exist a rig2mocap candidates file
% (2) there exist a common point between the two cameras

clc
close all
clear

% set parameters

% scene=5;%
% keyboxID=14;%
% minSample=1;
% maxSample=15412;
% frame=5;
% keyplaneID=[frame 2];%

scene=5;%
keyboxID=14;%
minSample=1;
maxSample=20412;
frame=5;
keyplaneID=[frame 2];%

% scene=6;%
% keyboxID=17;%
% minSample=11962;
% maxSample=27962;
% frame=66;
% keyplaneID=[66 2];%

% scene=3;%
% keyboxID=17;%
% minSample=1;
% maxSample=28499;
% frame=45;
% keyplaneID=[frame 4];%

% scene=3;%
% keyboxID=17;%
% minSample=18899;
% maxSample=48899;
% frame=130;
% keyplaneID=[frame 2];%


% 
% scene=21;%
% keyboxID=16;%
% minSample=1;
% maxSample=20760;
% frame=35;
% keyplaneID=[frame 7];%

% scene=51;%
% keyboxID=29;%
% minSample=1;
% maxSample=19800;
% frame=29;
% keyplaneID=[frame 6];%





rootPath="C:\lib\boxTrackinPCs\";
step=10;

% load Tm_c candidates
Tm_c_candidates=loadTcmCandidates(scene, rootPath, minSample, maxSample, step);
% load keybox pose in m world
[Tkeybox_m,~,~]=loadGTData_v2(rootPath, scene, keyboxID);

% Perform Tkeyplane  pose estimation in mm
%     detect planes in frame 
localPlanes=detectPlanes(rootPath,scene,frame);
% % code to recompute the key plane
keyFrames=loadKeyFrames(rootPath,scene);
% figure,
% myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(frame)]).acceptedPlanes)
% title (['boxes detected in scene/frame ' num2str(scene) '/' num2str(frame)])
% return

%     extract pose of plane 
keyPlane=loadPlanesFromIDs(localPlanes,keyplaneID);
TkeyPlane_h=keyPlane.tform;%in mt
TkeyPlane_h(1:3,4)=TkeyPlane_h(1:3,4)*1000;%in mm

NmbCandidates=size(Tm_c_candidates,1);
er=zeros(1,NmbCandidates);
et=zeros(1,NmbCandidates);
Th_c=loadTh_c(rootPath,scene,frame);
Theight=eye(4);
Theight(1:3,1:3)=[0 1 0 ; 0 0 1 ; 1 0 0];

% process candidates
for i=1:NmbCandidates
    Tm_c=assemblyTmatrix(Tm_c_candidates(i,:));
    % compute Tm_h
    Tm_h=Tm_c*inv(Th_c);
%   project TkeyPlane_h
    TkeyPlane_m=Tm_h*TkeyPlane_h*Theight;
    [ets,ers] = computeSinglePoseError(TkeyPlane_m,Tkeybox_m);
    er(i)=ers;
    et(i)=ets;
end

fs=960;
[~, index]=min(et);
% convert index to seconds
index_s=(minSample+(index*step))/fs;
% convert seconds to sample number
index_sample=index_s*fs;
% convert sample to ticks
tickMin=convertSample2TickMocap(rootPath,index_sample,scene,fs,1e7);

% compute the offset
% offset_synch=computeOffsetByScene_resync(scene);
offset_synch=0;
[~, ticksSynch_raw]=loadTm_c(rootPath,scene,frame,offset_synch);

offset_ticks=max(tickMin,uint64(ticksSynch_raw))-min(tickMin,uint64(ticksSynch_raw));
% offset_ticks=tickMin-uint64(ticksSynch_raw);
offset_samples=convertTick2SampleMocap(rootPath,offset_ticks,scene,fs,1e7);

samplesSynch_raw=convertTick2SampleMocap(rootPath,ticksSynch_raw,scene,fs,1e7);
samplesVector=minSample:step:maxSample;
iraw=computeClosestIndex(double(samplesSynch_raw),samplesVector');


figure,
subplot(211),...
    plot(samplesVector,er)
    hold
%     stem(round(band/scale)/2, er(round(band/scale)/2),'filled')
    ylabel 'e_r (deg)'
    grid
    axis tight
    title (['Error for a keyplane in scene=' num2str(scene) '. Offset=' num2str(double(offset_ticks)*1e-7) ' s' ])

subplot(212),...
    plot(samplesVector,et)
    hold
    stem(samplesVector(index),et(index),"filled",'g')
    stem(samplesVector(iraw),et(iraw),"filled",'r')
    ylabel 'e_t (mm)'
    grid
    xlabel (['time in ms with step: ' num2str(step) ])
    title (['Offset ticks=' num2str(double(offset_ticks)) '. Red e_t.= ' num2str([et(iraw)])  '. Green e_t= ' num2str(et(index)) ])
    axis tight

samplesVector(end)-samplesVector(iraw)
