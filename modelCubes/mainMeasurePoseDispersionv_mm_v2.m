% This script measures the dispersion of estimated poses that belong 
% two planes. The estimations were achieved with the pipeline (1). 
% Error metrics. Translation error, Rotation error


clc
close all
clear all
% parameters
keybox=15;%box selected to measure de pose error
scene=5;%
keyplaneID=[5 3];
rootPath="C:\lib\boxTrackinPCs\";
%% load key frames
keyframes=loadKeyFrames(rootPath,scene);
% keyframes=[2:9 20:29 40 41 43:44 53:62];

%% extract planes on key frames
localPlanes=detectPlanes(rootPath,scene,keyframes);
%% track keyPlaneID between processed frames
keyPlaneTwins=trackKeyPlane(keyplaneID,localPlanes,keyframes);
%% compute the mean value of the keyplane pose
Tmean = computeMeanT(localPlanes, keyPlaneTwins);
% conversion to mm
Tmean_mm=Tmean;
Tmean_mm(1:3,4)=Tmean_mm(1:3,4)*1000;
er=[];
et=[];
eL1=[];
eL2=[];

[~, L1ref, L2ref]=loadGTData(rootPath, scene, keybox);%length is loaded in cm
Nt=size(keyPlaneTwins,1);
%% compute pose error and length error
for i=1:Nt
    currentTwinID=keyPlaneTwins(i,:);
    currentTwin=loadPlanesFromIDs(localPlanes,currentTwinID);
% load Lengths
    L1=currentTwin.L1*100;%cm
    L2=currentTwin.L2*100;%cm
    eL1=[eL1 abs(L1ref-L1)];
    eL2=[eL2 abs(L2ref-L2)];

    Tbox=currentTwin.tform;%distance in mt, angles in rad or degrees
%     conversion to mm
    Tbox_mm=Tbox;
    Tbox_mm(1:3,4)=Tbox_mm(1:3,4)*1000;
    [ets,ers] = computeSinglePoseError(Tbox_mm,Tmean_mm);
    et=[et ets];%mm
    er=[er ers];
end

% compute variance in pose error
t_var=mean(et*et');
r_var=mean(er*er');


% plot results

myTickLabels=convertIDsToCell(keyPlaneTwins);
figure,
subplot (211),...
    stem(et)
    xticks([1:Nt])
    xticklabels(myTickLabels)
    xtickangle(90)
    ylabel (['e_t (mm). \sigma_t=' num2str(sqrt(t_var),'%.1f')])
    grid on
title (['Pose dispersion in scene ' num2str(scene) ...
    '. Keybox= ' num2str(keybox) '. KeyPlane= ' num2str(keyplaneID(1)) '-' num2str(keyplaneID(2)) ])    
subplot (212),...
    stem(er)
    ylabel (['e_r (r). \sigma_r=' num2str(sqrt(r_var),'%.1f')])
    xticks([1:Nt])
    xticklabels(myTickLabels)
    xtickangle(90)
    xlabel 'frame ID'
    grid on


figure,
subplot (411),...
    stem(et)
    xticks(1:Nt)
    xticklabels(myTickLabels)
    xtickangle(90)
    ylabel (['e_t (mm). \sigma_t=' num2str(sqrt(t_var),'%.1f')])
    grid on
title (['Pose dispersion in scene ' num2str(scene) ...
    '. Keybox= ' num2str(keybox) '. KeyPlane= ' num2str(keyplaneID(1)) '-' num2str(keyplaneID(2)) ])    
subplot (412),...
    stem(er)
    ylabel (['e_r (r). \sigma_r=' num2str(sqrt(r_var),'%.1f')])
    xticks(1:Nt)
    xticklabels(myTickLabels)
    xtickangle(90)
    grid on
subplot(413),...
    stem(eL1)
    ylabel (['e_{L_1 ;' num2str(L1ref) ' (cm)}'])
    xticks(1:Nt)
    xticklabels(myTickLabels)
    xtickangle(90)
    grid on
subplot(414),...
    stem(eL2)
    ylabel (['e_{L_2 ;' num2str(L2ref) ' (cm)}'])
    xticks(1:Nt)
    xticklabels(myTickLabels)
    xtickangle(90)
    xlabel 'frame ID'
    grid on    


