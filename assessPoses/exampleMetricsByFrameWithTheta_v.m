clc
close all
clear

sessionID=10;
[dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID);
theta_v=0.1:0.1:0.5;
Ntheta=length(theta_v);
tao=10;

keyFrames=loadKeyFrames(dataSetPath,sessionID);
keyFramesT=14:1:19;
% keyFramesT=360:1:365;
Nkft=length(keyFramesT);
indexkfT=zeros(Nkft,1);
for i=1:Nkft
    indexkfT(i)=find(keyFrames==keyFramesT(i));
end


% read json file
fileName='estimatedPoses.json';
jsonpath=fullfile(evalPath,['session' num2str(sessionID)], fileName);
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    estimatedPoses = jsondecode(str);

DP_v=zeros(Nkft,Ntheta);
DPm_v=zeros(Nkft,Ntheta);
precision_v=zeros(Nkft,Ntheta);
recall_v=zeros(Nkft,Ntheta);

for i=1:Nkft
    frameID=keyFrames(indexkfT(i));
    pps=getPPS(dataSetPath,sessionID,frameID);
    % extract estimations of an specific frame
    estimatedPose=estimatedPoses.(['frame' num2str(frameID)]);
    for j=1:Ntheta
        theta=theta_v(j);
        if ~isempty(estimatedPose)
            [DP, DPm, precision, recall] = computeMetricsByFrame(estimatedPose,theta,tao, pps);
        else
            continue
        end
        DP_v(i,j)=DP;
        DPm_v(i,j)=DPm;
        precision_v(i,j)=precision;
        recall_v(i,j)=recall;
    end
end

xmin=0;
xmax=0.5;
ymin=0;
ymax=1;
% plot recall
figure,
for i=1:Nkft
    recallByTheta=recall_v(i,:);
    subplot(2,3,i),
    stem(theta_v,recallByTheta)
    xlabel 'theta'
    ylabel 'recall'
    grid
    title (['Frame=' num2str(keyFrames(indexkfT(i))) '. Tao=' num2str(tao) ])
    axis([xmin xmax ymin ymax]);
end
% plot precision
figure,
for i=1:Nkft
    precisionByTheta=precision_v(i,:);
    subplot(2,3,i),
    stem(theta_v,precisionByTheta)
    xlabel 'theta'
    ylabel 'precision'
    grid
    title (['Frame=' num2str(keyFrames(indexkfT(i))) '. Tao=' num2str(tao) ])
    axis([xmin xmax ymin ymax]);
end

