function writeFileBySession_woutTitle(sessionID,dataPath,fileName,dataToWrite)
%WRITEFILEBYSESSION Summary of this function goes here
%   Detailed explanation goes here
% dataToWrite must be a table object

%% create folder
% save the current path
currentcd=pwd;
% go to evalpath 
cd (dataPath);
% create folder
folderName=['session' num2str(sessionID)];
folderExists=isfolder(folderName);
if ~folderExists
    mkdir (folderName);
end
% return to saved path
cd (currentcd);


%% write to csv file
filePath=fullfile(dataPath, folderName, fileName);
% existFlag=exist(filePath, 'file');

writetable(dataToWrite,filePath,'WriteMode','Append',...
    'WriteVariableNames',false) 

% if ~existFlag
% %     write with header
%     writetable(dataToWrite,filePath,'WriteRowNames',true)
% %     writematrix(dataToWrite,filePath)
% else
% %     write without header
%     writetable(dataToWrite,filePath,'WriteMode','Append',...
%     'WriteVariableNames',false) 
% %     writematrix(dataToWrite,filePath,'WriteMode','append') 
% % %     writematrix(M2,'M.xls','WriteMode','append')
% end

end





