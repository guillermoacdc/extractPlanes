clc
close all
clear

sessionID=13;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
algorithm=1;%wpk_algorithm
planeType=0;
keyFrames=loadKeyFrames(dataSetPath,sessionID);
targetFrames=keyFrames;
% targetFrames=keyFrames(246:276);%frames 728 a 758
% targetFrames=50:57;

theta=0.5;
tao=50;

% compute index of target frames
Ntf=length(targetFrames);
indexkfT=zeros(Ntf,1);
for i=1:Ntf
    indexkfT(i)=find(keyFrames==targetFrames(i));
end
% compute pps at frame 1 of target frames
pps1=getPPS(dataSetPath,sessionID,targetFrames(1));
Npps=size(pps1,1);
% read json file
fileName=['estimatedPoses_ia' num2str(algorithm) '_planeType' num2str(planeType) '.json'];
jsonpath=fullfile(evalPath,['session' num2str(sessionID)], fileName);
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    estimatedPoses = jsondecode(str);
% init outputs
precision_v=zeros(Ntf,1);
recall_v=zeros(Ntf,1);
trendDetections=zeros(Npps,Ntf);
trendIDEstimations=zeros(Npps,2*Ntf);
k=1;
for i=1:Ntf
    frameID=keyFrames(indexkfT(i));
    disp(['processing frame ' num2str(frameID)])
    if frameID==20
        disp('stop the world')
    end
    pps=getPPS(dataSetPath,sessionID,frameID);
    % extract estimations of an specific frame
    estimatedPose=estimatedPoses.(['frame' num2str(frameID)]);
%     for j=1:Ntheta
%         theta=theta_v(j);
        if ~isempty(estimatedPose)
            [precision, recall, matchM] = computeMetricsByFrame_topPlanes(estimatedPose,theta,tao, pps);
        else
            continue
        end
        trendDetectionsWithEstimatedID=computeTrendDetections(matchM, pps1);
        trendDetections(:,i)=trendDetectionsWithEstimatedID(:,1);
        precision_v(i)=precision;
        recall_v(i)=recall;
        trendIDEstimations(:,[k,k+1])=trendDetectionsWithEstimatedID(:,2:3);
        k=k+2;
%     end
end


C = trendDetections;
C= [C, zeros(Npps,1)];%to have one column per frame
C=C';
C=[C, zeros(Ntf+1,1)];%to have one row per box
C=C';
s=pcolor(C);
s.EdgeColor = [1 0.7 0.3];
% s.LineWidth = 6;
yticks(1:Npps)
yticklabels(pps1)
xticks(1:Ntf)
xticklabels(targetFrames)
colormap(gray(2))
% adjust ticklabels away from axes
axis ij
% axis square
xlabel 'frames'
ylabel (['plane segment ID in PPS. ' num2str(Npps) ' boxes'])
title (['Detected objects in session ' num2str(sessionID) ' with algorithm wpk' num2str(algorithm)])

