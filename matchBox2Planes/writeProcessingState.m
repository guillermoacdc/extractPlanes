function [outputArg1,outputArg2] = writeProcessingState(logtxt,evalPath,sessionID)
%WRITEPROCESSINGSTATE Summary of this function goes here
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




%% write to csv file
fileName='processingState.txt';
filePath=fullfile(evalPath, folderName, fileName);
% filePath=[evalPath '/' folderName '/' fileName];
existFlag=exist(filePath, 'file');

if existFlag~=2
%     create the file
    fileID = fopen(filePath,'w');
    fprintf(fileID,'%s \n', logtxt);
    fclose(fileID);
else
%     append data to the file
    fileID = fopen(filePath,'a');
    fprintf(fileID,'%s \n', logtxt);
    fclose(fileID);
end
end

