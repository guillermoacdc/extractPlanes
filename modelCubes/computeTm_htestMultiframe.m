clc
close all
clear

scene=5;%
frame=102;
rootPath="C:\lib\boxTrackinPCs\";

keyframes=loadKeyFrames(rootPath,scene);
% compute T for all keyframes
N=size(keyframes,2);
for i=1:N
    Tm_h = computeTm_h(rootPath,scene, keyframes(i));%length in mm
    Tacc.(['fr' num2str(i)])=Tm_h;
end
% compute mean value for T
tacc=[];
r1acc=[];
r2acc=[];
r3acc=[];

for i=1:N
    Taux=Tacc.(['fr' num2str(i)]);
    t=Taux(1:3,4);
    r1=Taux(1:3,1);
    r2=Taux(1:3,2);
    r3=Taux(1:3,3);

    tacc=[tacc t];
    r1acc=[r1acc r1];
    r2acc=[r2acc r2];
    r3acc=[r3acc r3];
end
tmean=mean(tacc,2);
r1mean=mean(r1acc,2);
r2mean=mean(r2acc,2);
r3mean=mean(r3acc,2);

Tmean=eye(4);
Tmean(1:3,4)=tmean;
Tmean(1:3,1:3)=[r1mean r2mean r3mean]
