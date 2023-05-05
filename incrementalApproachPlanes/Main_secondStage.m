% computes the estimation and assesment of pose estimation for a set of
% sessions with two randomized approaches

clc
close all
clear

randomV=[1 2 1 1 2 2 1 2 2 1 2 2 1 1 1 2 1 2];
% low occlussion scenes
sessionsID=[3	10	12	13	17	19	20	25	27	32	33	35	36	39	45	52	53	54];
Ns=size(sessionsID,2);

for i=1:Ns
    sessionID=sessionsID(i);
    if randomV(i)==1
        estimatePoses_ia1(sessionID);
        estimatePoses_ia2(sessionID);
    else
        estimatePoses_ia2(sessionID);
        estimatePoses_ia1(sessionID);
    end
end