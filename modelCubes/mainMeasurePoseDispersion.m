% This script measures the dispersion of estimated poses that belong 
% two planes. The estimations were achieved with the pipeline (1). 
% Error metrics. Translation error, Rotation error


clc
close all
clear all

keybox=15;%box selected to measure de pose error
scene=5;%
keyplaneID=[5 3];
rootPath="C:\lib\boxTrackinPCs\";

keyframes=loadKeyFrames(rootPath,scene);
% keyframes=[2:9 20:29 40 41 43:44 53:62];
localPlanes=detectPlanes(rootPath,scene,keyframes);

keyPlaneTwins=trackKeyPlane(keyplaneID,localPlanes,keyframes);

Tmean = computeMeanT(localPlanes, keyPlaneTwins);

er=[];
et=[];

Nt=size(keyPlaneTwins,1);

for i=1:Nt
    currentTwinID=keyPlaneTwins(i,:);
    currentTwin=loadPlanesFromIDs(localPlanes,currentTwinID);
    Tbox=currentTwin.tform;%distance in mt, angles in rad or degrees
    [ets,ers] = computeSinglePoseError(Tbox,Tmean);
    et=[et ets];
    er=[er ers];
end

% compute variance
t_var=mean(et*et');
r_var=mean(er*er');


myTickLabels=convertIDsToCell(keyPlaneTwins);
figure,
subplot (211),...
    stem(et)
    xticks([1:Nt])
    xticklabels(myTickLabels)
    xtickangle(90)
    ylabel (['e_t (mm). \sigma_t=' num2str(sqrt(t_var))])
    grid on
subplot (212),...
    stem(er)
    ylabel (['e_r (rad). \sigma_r=' num2str(sqrt(r_var))])
    xticks([1:Nt])
    xticklabels(myTickLabels)
    xtickangle(90)
    grid on