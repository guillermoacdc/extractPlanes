% Computes the offset time between two cameras: mocap, HL2. Assumptions
% (1) there exist a rig2mocap candidates file
% (2) there exist a common point between the two cameras

clc
close all
clear

% set parameters

% scene=3;%
% keyboxID=17;%
% minSample=18900;
% maxSample=48900;
% frame=130;
% keyplaneID=[frame 2];%

% scene=5;%
% keyboxID=14;%
% minSample=1;
% maxSample=20413;
% frame=5;
% keyplaneID=[frame 2];%

% scene=6;%
% keyboxID=17;%
% minSample=2963;
% maxSample=32963;
% frame=66;
% keyplaneID=[frame 2];%

% scene=21;%
% keyboxID=16;%
% minSample=1;
% maxSample=21000;
% frame=35;
% keyplaneID=[frame 7];%

scene=51;%
keyboxID=29;%
minSample=1;
maxSample=19800;
frame=29;
keyplaneID=[frame 6];%

rootPath="C:\lib\boxTrackinPCs\";
step=10;

% load Tm_c candidates
Tm_c_candidates=loadTcmCandidates(scene, rootPath, minSample, maxSample, step);
% load keybox pose in m world


% [Tkeybox_m,~,~]=loadGTData_v2(rootPath, scene, keyboxID);

initialPoses=loadInitialPose_v2(rootPath,scene);
% boxLengths = loadLengths(rootPath,scene);
indexKeyBox=find(initialPoses(:,1)==keyboxID);
Tkeybox_m=assemblyTmatrix(initialPoses(indexKeyBox,[2:13]));


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
    if i==1314
        disp('stop the code')
    end
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
%% offset computation
% detect the index where the error is minimum
[~, index]=min(et);%
% % limit the search to the second half of the vector
% Nhalf=round(size(et,2)/2);
% etsec=et(Nhalf:end);
% [~, index2]=min(etsec);
% index=Nhalf+index2;

% convert index to seconds
index_s=(minSample+(index*step))/fs;
% convert seconds to sample number in mocap sensor
index_sample=index_s*fs;
% convert sample to ticks
tickMin_mocap=convertSample2TickMocap(rootPath,index_sample,scene,fs,1e7);

% compute the tickRaw_mocap from frame
[~,discardedInitH]=synchInitEndh(rootPath,scene);
if discardedInitH==0
    [~, tickRaw_H]=loadTm_c(rootPath,scene,frame,0);
    timeStamp_m=synchInitEndm_v4(rootPath,scene);
    closestIndex=computeClosestIndex(uint64(tickRaw_H),timeStamp_m(:,1));
    tickRaw_M=timeStamp_m(closestIndex);
else
    tickRaw_M=convertKeyFrameh2MocapTick(frame,rootPath,scene);
    tickRaw_M=tickRaw_M(1);%discard sample number
end
% compute the difference
sign=1;
offset_ticks=tickMin_mocap-tickRaw_M;
if offset_ticks==0
    sign=-1;
    offset_ticks=tickRaw_M-tickMin_mocap;
end
% compute raw index to plot raw data
samplesSynch_raw = convertTick2SampleMocap(rootPath,tickRaw_M,scene,960,1e7);


% samplesSynch_raw=convertFrame2MocapSample(rootPath,scene,frame);
samplesVector=minSample:step:maxSample;
iraw=computeClosestIndex(double(samplesSynch_raw),samplesVector');

dispOffset=sign*double(offset_ticks)
figure,
subplot(211),...
    plot(samplesVector,er)
    hold
    stem(samplesVector(index),er(index),"filled",'g')
    stem(samplesVector(iraw),er(iraw),"filled",'r')
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
    title (['Offset ticks=' num2str(dispOffset) '. Red e_t.= ' num2str([et(iraw)])  '. Green e_t= ' num2str(et(index)) ])
    axis tight

% samplesVector(end)-samplesVector(iraw)

