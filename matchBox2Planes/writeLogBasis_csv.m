function  writeLogBasis_csv(er, et, eL1, eL2,...
    eADD, n_inliers, dc, boxID, evalPath, frame, scene, planeID)
%WRITELOGBASIS_CSV Summary of this function goes here
%   Detailed explanation goes here

%% create folder
% save the current path
currentcd=pwd;
% go to evalpath 
cd (evalPath);
% create folder
folderName=['scene' num2str(scene)];
folderExists=isfolder(folderName);
if ~folderExists
    mkdir (folderName);
end
% return to saved path
cd (currentcd);

%% create table object
T = table(frame, er, et, eADD, eL1, eL2, n_inliers, dc, planeID);


%% write to csv file
fileName=['box' num2str(boxID) '.csv'];
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

