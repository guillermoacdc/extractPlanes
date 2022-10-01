% script to validate Th_c and Tm_c
clc
close all
clear

% set parameters

scene=5;%
rootPath="C:\lib\boxTrackinPCs\";
keyboxID=14;%
minSample=1000;
maxSample=15000;
%load key frames
frame=5;
step=10;
keyplaneID=[5 2];%
% (scene, rootPath, minSample, maxSample, step)
% load Tm_c candidates
Tm_c_candidates=loadTcmCandidates(scene, rootPath, minSample, maxSample, step);
% load keybox pose in m world
[Tkeybox_m,~,~]=loadGTData(rootPath, scene, keyboxID);

%% Perform Tkeyplane  pose estimation in mm
%     detect planes in frame 
localPlanes=detectPlanes(rootPath,scene,frame);

% figure,
% myPlotPlanes_v2(localPlanes,localPlanes.(['fr' num2str(frame)]).acceptedPlanes);
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


for i=1:NmbCandidates
    Tm_c=assemblyTmatrix(Tm_c_candidates(i,:));
%     Tm_c(1:3,4)=1000*Tm_c(1:3,4);
    % compute Tm_h
    Tm_h=Tm_c*inv(Th_c);
    TkeyPlane_m=Tm_h*TkeyPlane_h*Theight;
    [ets,ers] = computeSinglePoseError(TkeyPlane_m,Tkeybox_m);
    er(i)=ers;
    et(i)=ets;
end

fs=960;
[~, sampleMin]=min(et);
% compute the offset
[~, times]=loadTm_c(rootPath,scene,frame);
sammpleSynch=times*fs;
offset=abs((step*sampleMin)-sammpleSynch);


samplesVector=minSample:step:maxSample;
figure,
subplot(211),...
%     plot(Tm_c_candidates(:,1),er)
    stem(samplesVector,er)
    hold
%     stem(round(band/scale)/2, er(round(band/scale)/2),'filled')
    ylabel 'e_r (deg)'
    grid
    axis tight
    title (['Error for a keyplane in frame=' num2str(frame) ', scene=' num2str(scene) '. Offset=' num2str(offset/fs) ' s' ])

subplot(212),...
%     plot(Tm_c_candidates(:,1),et)
    stem(samplesVector,et)
    hold
%     stem(round(band/scale)/2, et(round(band/scale)/2),'filled')
    ylabel 'e_t (mm)'
    grid
    xlabel (['Samples of mocap with step: ' num2str(step) ])
    axis tight


% 
% iup=find(et>937.6793)
% idown=find(et<933.6793)
% intersect(iup,idown);

