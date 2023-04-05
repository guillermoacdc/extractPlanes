clc
close all
clear

sessionIDs=[13 15	16	17	18	19	20	21	25	27	32	33	35	36	39	45	52	53	54];
N=length(sessionIDs);

% zip -r PointClouds.zip PointCloud
fileName='ZippingFolders.txt';
fileID = fopen(fileName,'a');
fmt='%s \n';
for i=1:N
    sessionID=sessionIDs(i);
    dataPath=['/home/gacamacho/Documents/muelle6DViCuT/session' num2str(sessionID) '/'];
    myCommand=['zip -r ' dataPath 'PointClouds.zip ' dataPath  'PointClouds'];
    fprintf(fileID, fmt ,myCommand);
end
fclose(fileID);
