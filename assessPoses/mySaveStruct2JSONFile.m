function  mySaveStruct2JSONFile(theStruct,fileName,savePath,sessionID)
%MYSAVESTRUCT2JSONFILE Summary of this function goes here
%   Detailed explanation goes here
    str = jsonencode(theStruct);
    % add a return character after all commas:
    new_string = strrep(str, ',', ',\n');
    % add a return character after curly brackets:
    new_string = strrep(new_string, '{', '{\n');
    % etc...
    % Write the string to file
    % create folder
        % save the current path
        currentcd=pwd;
        % go to savePath
        cd (savePath);
        % create folder
        folderName=['session' num2str(sessionID)];
        folderExists=isfolder(folderName);
        if ~folderExists
            mkdir (folderName);
        end
        % return to saved path
        cd (currentcd);
    % save file in created folder
        cfolderPath=fullfile(savePath,folderName,fileName);
        fid = fopen(cfolderPath,'w');
        fprintf(fid, new_string); 
        fclose(fid);
end

