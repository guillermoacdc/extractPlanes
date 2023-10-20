clc
close all
clear

fileName="visiblePlanesByFrame.json";
sessionID=3;
dataSetPath=computeReadPaths(sessionID);
visiblePlanesBySession = loadVisiblePlanesBySession(fileName,sessionID);
keyFrames=loadKeyFrames(dataSetPath,sessionID);
pps=getPPS(dataSetPath, sessionID,keyFrames(1));
Nkf=length(keyFrames);
Npps=length(pps);

%% compute vpbb: visible planes by box
vpbb=zeros(Nkf+1,Npps+1);%visible planes by box
vpbb(:,1)=[0 keyFrames];
vpbb(1,:)=[0 pps'];

for i=1:Nkf
    frameID=keyFrames(i);
    myStruct=visiblePlanesBySession.(['frame' num2str(frameID)]);
    Nb=size(myStruct,1);
%     disp(['index ' num2str(i)])
%     if i==80
%         disp('stop')
%     end
    for j=1:Nb
        if ~isempty(myStruct(j).boxID)
            targetColumn=find(pps==myStruct(j).boxID)+1;
    %         targetRow=find(keyFrames==frameID)+1;
            vpbb(i,targetColumn)=size(myStruct(j).planesID,1);
        end
    end
end

%% compute stats on vpbb
nvfbb = loadNumberVigentFramesByBox(sessionID);
ref=0:3;%reference to compute ocurrencies
Nref=length(ref);
stats=zeros(Nref+1,Npps+1);
stats(:,1)=[0 ref];
stats(1,:)=[0 pps'];

for i=1:Npps
    bbf=vpbb(:,i+1);
    bbf=bbf(1:nvfbb(i));%descart frames where the box is missing
    ocurrencies=myComputeOcurrencies(bbf,ref);
    stats(2:end,i+1)=ocurrencies/nvfbb(i);
end
stats
%% compute votes
votes=zeros(Npps,1);
for i=1:Npps
    percents=stats(3:end,i+1);
    [~, votes(i)]=max(percents);
end
%% count votes and sort by count
ref=1:3;
oc=myComputeOcurrencies(votes,ref);
refoc=[ref' oc]


function ocurrencies=myComputeOcurrencies(bbf,ref)
% computes the number of ocurrencies of a target value in a vector bbf
% the target value can be an scalar or a vector and resides on the input ref
%     ref=0:3;
    Nref=length(ref);
    ocurrencies=zeros(Nref,1);
    for i=1:Nref
        oct=find(bbf==ref(i));
        ocurrencies(i)=length(oct);
    end

end