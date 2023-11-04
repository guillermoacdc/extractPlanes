clc
close all
clear

% load global planes by frame


[localAssignedP, localUnassignedP] = cuboidDetectionAndUPdate(myPlanes, ...
        th_angle, planeIndex,conditionalAssignationFlag,...
        globalAcceptedPlanes)