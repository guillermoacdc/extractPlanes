clc
close all
clear

sessionIDs=[1	2	3	4	5	6	7	10	12];
sourceDataPath='G:\Mi unidad\boxesDatabaseSample';
fileName='sessionDescriptor.csv';
destinationPath='D:\muelle6DViCuT';
patFactorsForSession='G:\Mi unidad\various6DViCuT\factorLeveles\factorsForSession_p1.csv';
factorsForSession_t=readtable(patFactorsForSession);
factorsForSession_a=table2array(factorsForSession_t);
N=length(sessionIDs);
for i=1:N
    sessionID=sessionIDs(i);
    indexSession=find(factorsForSession_a(:,1)==sessionID);
    factorsForSession=factorsForSession_a(indexSession,2:end);
    Tnew = updateSessionDescriptor(sessionID,sourceDataPath,factorsForSession);
    dataToWrite=[Tnew.numberOfBoxes Tnew.mocapRecordedFrames Tnew.factorLevels];
    writeFileBySession(sessionID,destinationPath,fileName,dataToWrite)
    writeFileBySession(sessionID,destinationPath,fileName,Tnew.poseByBoxAndFrame);
    disp(['session ' num2str(sessionID) ' updated with success'])
end
