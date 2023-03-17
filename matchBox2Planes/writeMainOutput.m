function  writeMainOutput(evalPath,sessionID,frameID,boxID,estimatedPlaneID,...
    estimatedPose_m,eADD,tao,theta)
%writeMainOutput Creates a csv file in the evalPath with main outputs
%   Detailed explanation goes here

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

Restimated=estimatedPose_m(1:3,1:3);
Restimated=Restimated(1:end);
testimated=estimatedPose_m(1:3,4)';
%% create table object
T = table(frameID, boxID, estimatedPlaneID, Restimated, testimated, eADD );


%% write to csv file
fileName=['estimatedPoseA_session' num2str(sessionID) '_tao' num2str(tao) '_theta' num2str(theta) '.csv'];
filePath=[evalPath '\' folderName '\' fileName];
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

