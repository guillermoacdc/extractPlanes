% This script measures the dispersion of estimated poses that belong 
% two planes. The estimations were achieved with the pipeline (1). 
% Error metrics. Translation error, Rotation error


clc
close all
clear all

keybox=19;%box selected to measure de pose error
scene=5;%
keyplaneID=[20 4];
rootPath="C:\lib\boxTrackinPCs\";

keyframes=loadKeyFrames(rootPath,scene);
% keyframes=[2:9 20:29 40 41 43:44 53:62];
localPlanes=detectPlanes(rootPath,scene,keyframes);

keyPlaneTwins=trackKeyPlane(keyplaneID,localPlanes,keyframes);

Tmean = computeMeanT(localPlanes, keyPlaneTwins);
% conversion to mm
Tmean_mm=Tmean;
Tmean_mm(1:3,4)=Tmean_mm(1:3,4)*1000;
er=[];
et=[];

Nt=size(keyPlaneTwins,1);
% compute pose error
for i=1:Nt
    currentTwinID=keyPlaneTwins(i,:);
    currentTwin=loadPlanesFromIDs(localPlanes,currentTwinID);
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
    ylabel (['e_t (mm). \sigma_t=' num2str(sqrt(t_var))])
    grid on
title (['Pose dispersion in scene ' num2str(scene) ...
    '. Keybox= ' num2str(keybox) '. KeyPlane= ' num2str(keyplaneID(1)) '-' num2str(keyplaneID(2)) ])    
subplot (212),...
    stem(er)
    ylabel (['e_r (rad). \sigma_r=' num2str(sqrt(r_var))])
    xticks([1:Nt])
    xticklabels(myTickLabels)
    xtickangle(90)
    xlabel 'frame ID'
    grid on
