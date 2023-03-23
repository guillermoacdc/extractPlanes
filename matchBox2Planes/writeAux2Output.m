function writeAux2Output(dataSetPath, evalPath,sessionID,frameID,...
    derivedMetrics,NestimatedPlanes,tao,theta)

%% create folder
% save the current path
currentcd=pwd;
% go to evalpath 
cd (evalPath);
% create folder
folderName=['scene' num2str(sessionID)];
folderExists=isfolder(folderName);
if ~folderExists
    mkdir (folderName);
end
% return to saved path
cd (currentcd);

%% create table object
boxByFrameA = loadBoxByFrame(dataSetPath,sessionID);
extractedBoxes=computeIndexesBeforeFrame(boxByFrameA(:,3), frameID)-1;%number of extracted boxes from consolidation zone at an specific frame
DP=sum(derivedMetrics(:,2));
MD=sum(derivedMetrics(:,3));
MP=sum(derivedMetrics(:,4))-extractedBoxes;
SP=NestimatedPlanes-DP;
T=table(frameID, DP, MD, MP, SP);

%% write to csv file
fileName=['estimatedPoseA_session' num2str(sessionID) '_tao' num2str(tao) '_theta' num2str(theta) 'aux2.csv'];
% filePath=[evalPath '/' folderName '/' fileName];
filePath=fullfile(evalPath, folderName, fileName);
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