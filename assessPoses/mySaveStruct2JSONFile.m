function  mySaveStruct2JSONFile(theStruct,fileName,savePath,sessionID, folderFlag)
%MYSAVESTRUCT2JSONFILE Savaes a struct to a JSON file

if nargin<5
    folderFlag=true;
end
windowsFlag=false;
old=filesep;
if old=='\'
    windowsFlag=true;
end

%% put the data in a string of json format
if windowsFlag
    str = mps.json.encode(theStruct);
else
    str = jsonencode(theStruct);
end
    
    % add a return character after all commas:
    jsonFormat_string = strrep(str, ',', ',\n');
    % add a return character after curly brackets:
    jsonFormat_string = strrep(jsonFormat_string, '{', '{\n');
    
    if folderFlag
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
    else
        cfolderPath=fullfile(savePath,fileName);
    end
    fid = fopen(cfolderPath,'w');
    fprintf(fid, jsonFormat_string); 
    fclose(fid);
end

