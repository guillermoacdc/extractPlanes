clc
close all
clear

rootPath="G:\Mi unidad\boxesDatabaseSample\";
markerIDPath="D:\installers2022-2\AnotadorJC\Build2\Anotador_Data\StreamingAssets\Exogenous\";
scene=5;
%% loading json data
MoCapDescriptors = getJSONData(rootPath,scene);
%% updating descriptros
updateMoCapDescriptors = updateMocapJsonFile(scene,markerIDPath,MoCapDescriptors);
%% write updated data to a predefined folder
fileName='markerDescriptors.json';

str = jsonencode(updateMoCapDescriptors);
% add a return character after all commas:
new_string = strrep(str, ',', ',\n');
% add a return character after curly brackets:
new_string = strrep(new_string, '{', '{\n');
% etc...
% Write the string to file
fid = fopen(fileName,'w');
fprintf(fid, new_string); 
fclose(fid);