clc
close all
clear

sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];

Ns=size(sessionsID,2);
dataSetPath=computeMainPaths(sessionsID(1));
outputDataPath='D:\6DViCuT_p1\updatedGTPoses';
fileName='sessionDescriptor.csv';
% ground normal with slope
A=0.0048;
B=0.0261;
C=0.9996;
for i=1:Ns
    sessionID=sessionsID(i);
    boxesID=getPPS(dataSetPath,sessionID,1);
    Nb=size(boxesID,1);

% create file with header
    header=loadHeader(dataSetPath,sessionID);
    writeFileBySession_woutTitle(sessionID,outputDataPath,fileName,header)
    for j=1:Nb
        boxID=boxesID(j);
        display(['computing pose in box ' num2str(boxID) ' at session ' num2str(sessionID)])
        P_table=updateGTPoseBySession(sessionID, boxID, A, B, C);
        writeFileBySession_woutTitle(sessionID,outputDataPath,fileName,P_table)
    end
end