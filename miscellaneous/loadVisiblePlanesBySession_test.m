clc
close all
clear

fileName="visiblePlanesByFrame.json";
sessionID=10;
dataSetPath=computeReadPaths(sessionID);
visiblePlanesBySession = loadVisiblePlanesBySession(fileName,sessionID);
keyFrames=loadKeyFrames(dataSetPath,sessionID);
pps=getPPS(dataSetPath, sessionID,keyFrames(1));
M=length(keyFrames);
N=length(pps);
vpbb=zeros(M+1,N+1);%visible planes by box
vpbb(:,1)=[0 keyFrames];
vpbb(1,:)=[0 pps'];

for i=1:M
    frameID=keyFrames(i);
    myStruct=visiblePlanesBySession.(['frame' num2str(frameID)]);
    Nb=size(myStruct,1);
    disp(['index ' num2str(i)])
    if i==80
        disp('stop')
    end
    for j=1:Nb
        if ~isempty(myStruct(j).boxID)
            targetColumn=find(pps==myStruct(j).boxID)+1;
    %         targetRow=find(keyFrames==frameID)+1;
            vpbb(i,targetColumn)=size(myStruct(j).planesID,1);
        end
    end
end