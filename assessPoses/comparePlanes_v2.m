function [eADD] = comparePlanes_v2(gtPlane, detectedPlane,tao, NpointsDiagPpal)
%COMPAREPLANES compute error function eADD between estimated and ground truth
%values
% asume que las poses estimadas llegan en el sistema de coordeandas
% qm, en consecuencia, se eliminan las etapas que proyectaban a ese
% sistema. También se asume que las poses estimadas llegan en mm
%   Detailed explanation goes here

%% compute rotation error er
Tref=gtPlane.tform;
Testimated_m=detectedPlane.tform;%mt
[~, er]=computeSinglePoseError(Tref,Testimated_m);%as stated in Hodane 2016 we compute Reference-Estimated
spatialSampling=sqrt(gtPlane.L1^2+gtPlane.L2^2)/NpointsDiagPpal;
%% compute average distance distinguishable error eADD
% project the pc with the gt pose
     plane_model_gt=createPlanePCAtOrigin(gtPlane,spatialSampling);
% project the pc with the estimated pose
% to avoid error for length estimation, we use groundtruth length in the
% generation of estimated point cloud--highlight in the methods section!
detectedPlane.L1=gtPlane.L1;
detectedPlane.L2=gtPlane.L2;
plane_model_estimated=createPlanePCAtOrigin(detectedPlane,spatialSampling);
% compute the average distance distingushable
eADD=computeSingle_eADD(plane_model_gt,plane_model_estimated, er, tao);%mm


