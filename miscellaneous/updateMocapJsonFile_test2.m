clc
close all
clear

rootPath="G:\Mi unidad\boxesDatabaseSample\";
markerIDPath="D:\installers2022-2\AnotadorJC\Build2\Anotador_Data\StreamingAssets\Exogenous\";
fileName='markerDescriptors.json';
% scenes=[	2	3	4	5	6	7	10	12	13	15	16	17	18	19	20	21	25	27	32	33	35	36	39	45	52	53	54];
scenes=1;
N=size(scenes,2);
savePath="D:\jsonMocapFiles\";
for i=1:N
    scene=scenes(i);

    %% loading json data
    MoCapDescriptors = getJSONData(rootPath,scene);
    %% updating descriptros
    updateMoCapDescriptors = updateMocapJsonFile(scene,markerIDPath,MoCapDescriptors);
    %% write updated data to a predefined folder


    str = jsonencode(updateMoCapDescriptors);
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
        folderName=['session' num2str(scene)];
        folderExists=isfolder(folderName);
        if ~folderExists
            mkdir (folderName);
        end
        % return to saved path
        cd (currentcd);
    % save file in created folder
        fid = fopen(savePath+[folderName '\' fileName],'w');
        fprintf(fid, new_string); 
        fclose(fid);
end    