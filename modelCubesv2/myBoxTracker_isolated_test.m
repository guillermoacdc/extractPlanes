clc
close all
clear

% sessionsID=[ 3 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=10;% 
app='_vdebug';%appendix of the folder where results are saved
Ns=size(sessionsID,2);
evalPath=computeReadWritePaths(app);

pkFlagv=[0 1];% for wout and with previous knowledge
Npk=length(pkFlagv);
th_angle_deg=18;
conditionalAssignationFlag=0;
compensateHeight=50;%mm
estimationsPlanesFileName='estimatedPlanes.json';

for i=1:Ns
    sessionID=sessionsID(i);
    for j=1:Npk
        pk=pkFlagv(j);
        fileNameBoxes=['estimatedBoxes_pk' num2str(pk) '.json'];
        estimatedBoxPose=myBoxTracker_isolated(estimationsPlanesFileName,...
            sessionID, evalPath, th_angle_deg,conditionalAssignationFlag,compensateHeight, pk);
        % write json file to disk
        mySaveStruct2JSONFile(estimatedBoxPose,fileNameBoxes,evalPath,sessionID);
    end
end