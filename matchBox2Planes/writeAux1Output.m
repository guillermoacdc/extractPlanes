function  writeAux1Output(evalPath,sessionID,...
    frameID,boxID,estimatedPlaneID,eL1,eL2,eR,et,n_inliers,dc,tao,theta)
%WRITEAUX1OUTPUT Summary of this function goes here
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


%% create table object
T = table(frameID, boxID, estimatedPlaneID, eL1, eL2, eR, et, n_inliers, dc );


%% write to csv file
fileName=['estimatedPoseA_session' num2str(sessionID) '_tao' num2str(tao) '_theta' num2str(theta) 'aux1.csv'];
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

