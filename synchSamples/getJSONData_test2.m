clc
close all
clear

rootPath="G:\Mi unidad\boxesDatabaseSample\";
scene=5;
% loading json data
[values] = getJSONData(rootPath,scene);

% duplicating json data in a new file
% assuming your structure is saved to val:
str = jsonencode(values);
% add a return character after all commas:
new_string = strrep(str, ',', ',\n');
% add a return character after curly brackets:
new_string = strrep(new_string, '{', '{\n')
% etc...
% Write the string to file
fid = fopen("filename.json",'w');
fprintf(fid, new_string); 
fclose(fid);