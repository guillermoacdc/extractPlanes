clc
close all
clear all

scene=6;
rootPath="C:\lib\boxTrackinPCs\";


% %% load folder names in path 1
% path1= 'G:\Mi unidad\boxTrackingPCs\scene6\detectedPlanes'; 
% path1v2='G:\"Mi unidad"\boxTrackingPCs\scene6\detectedPlanes'; 
% folderName1=getFolderNames(path1);
% for i=1:size(folderName1,2)
%     aux=folderName1{i};
%     frames1(i)=str2num(aux(6:end));
% end

frames1=loadKeyFrames(rootPath,scene);

% load folder names in path 2
path2= 'C:\lib\boxTrackinPCs\scene6\detectedPlanes';

folderName2=getFolderNames(path2);
for i=1:size(folderName2,2)
    aux=folderName2{i};
    frames2(i)=str2num(aux(6:end));
end

% detect names in folder 1 that are not present in folder 2
missingFolders=setdiff(frames1,frames2)
return
for i=1:size(missingFolders,2)
    mycommand=['xcopy ' path1v2 '\frame' num2str(missingFolders(i)) ' ',...
        path2 '\frame' num2str(missingFolders(i))];
    [status,cmdout]=system(mycommand);
end

% the system instruction (line 29) is not working. 21/09/2022