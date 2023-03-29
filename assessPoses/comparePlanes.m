function [eADD] = comparePlanes(boxID, gtPose, detectedPlane,dataSetPath,tao)
%COMPAREPLANES compute error function eADD between estimated and ground truth
%values
% asume que las poses estimadas llegan en el sistema de coordeandas
% qm, en consecuencia, se eliminan las etapas que proyectaban a ese
% sistema. También se asume que las poses estimadas llegan en mm
%   Detailed explanation goes here


%% compute rotation error er
Tref=gtPose;
Testimated_m=detectedPlane.tform;%mt
[~, er]=computeSinglePoseError(Tref,Testimated_m);%as stated in Hodane 2016 we compute Reference-Estimated
%% compute lenght errors; eL1, eL2
% load gt lengths
lengths_array=getPreviousKnowledge(dataSetPath,boxID); % Id,Type,Heigth(cm),Width(cm),Depth(cm)
H=lengths_array(2)*10;%mm
W=lengths_array(3)*10;%mm
D=lengths_array(4)*10;%mm

if W>=D
    L1gt=D;
    L2gt=W;
else
    L1gt=W;
    L2gt=D;    
end
spatialSampling=sqrt(L1gt^2+L2gt^2)/20;
%% compute average distance distinguishable error eADD
    plane_model=createSingleBoxPC_topSide(L1gt,L2gt,H,spatialSampling);%centered in the origin
% project the pc with the gt pose
    plane_model_gt=myProjection_v3(plane_model,Tref);
% project the pc with the estimated pose
    plane_model_estimated=myProjection_v3(plane_model,Testimated_m);
% compute the average distance distingushable
eADD=computeSingle_eADD(plane_model_gt,plane_model_estimated, er, tao);%mm


