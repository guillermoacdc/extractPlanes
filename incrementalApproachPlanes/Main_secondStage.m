% computes the estimation and assesment of pose estimation for a set of
% sessions with two randomized approaches

clc
close all
clear

randomV=[1 2 1 1 2 2 1 2 2 1 2 2 1 1 1 2 1 2];
% low occlussion scenes
sessionsID=[3	10	12	13	17	19	20	25	27	32	33	45	52	53	54];%35	36	39
Ns=size(sessionsID,2);
planeType=1;
fileName1='estimatedPoses_ia1_t1.json';
fileName2='estimatedPoses_ia2_t1.json';
for i=1:Ns
    sessionID=sessionsID(i);
    if randomV(i)==1
        estimatePoses_ia1(sessionID, planeType, fileName1);
        estimatePoses_ia2(sessionID, planeType, fileName2);
    else
        estimatePoses_ia2(sessionID, planeType, fileName2);
        estimatePoses_ia1(sessionID, planeType, fileName1);
    end
end