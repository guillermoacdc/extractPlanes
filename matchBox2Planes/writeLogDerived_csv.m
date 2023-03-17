function  writeLogDerived_csv(rootPath, evalPath,scene,frame,derivedMetrics,NestimatedPlanes)
%WRITELOGDERIVED_CSV Summary of this function goes here
%   Detailed explanation goes here
%% create table object
boxByFrameA = loadBoxByFrame(rootPath,scene);
extractedBoxes=computeIndexesBeforeFrame(boxByFrameA(:,3), frame)-1;%number of extracted boxes from consolidation zone at an specific frame
DP=sum(derivedMetrics(:,2));
MD=sum(derivedMetrics(:,3));
MP=sum(derivedMetrics(:,4))-extractedBoxes;
SP=NestimatedPlanes-DP;
T=table(frame, DP, MD, MP, SP);


%% write to csv file
% create folder
folderName=[evalPath '\scene'  num2str(scene) ];
folderExists=isfolder(folderName);
if ~folderExists
    mkdir (folderName);
end

fileName='derivedMetrics.csv';
filePath=[evalPath '\scene'  num2str(scene) '\' fileName];
existFlag=exist(filePath, 'file');

if ~existFlag
%     write with header
    writetable(T,filePath,'WriteRowNames',true)
else
%     write without header
    writetable(T,filePath,'WriteMode','Append',...
    'WriteVariableNames',false) 
end

end

