clc
close all
clear

rootPath="C:\lib\boxTrackinPCs\";
scene=51;
keyframes=loadKeyFrames(rootPath,scene);
frame=keyframes(1);
t=computeToffsetForAScene(rootPath,scene,frame);