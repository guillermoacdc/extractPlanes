function [p1,p2] = loadMarkerPosition(sessionID,frameID, boxID)
%LOADMARKERPOSITION Summary of this function goes here
%   Detailed explanation goes here
markersPath0='D:\installers2022-2\AnotadorJC\Build2\Anotador_Data\StreamingAssets\Comas';

append = computeAppendMocapFileName(sessionID);
fileName=['corrida' num2str(sessionID) '-00' num2str(append) '.csv'];
markersPath=fullfile(markersPath0,fileName);


dataSetpath=computeMainPaths(sessionID);
folderPath=fullfile(dataSetpath,['session' num2str(sessionID)],'raw','MoCap');
fileName='markerDescriptors.json';
filePath=fullfile(folderPath,fileName);

fid = fopen(filePath); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);
% compute markers from boxID
markersBoxS=val.trackers.markers;
markerBoxC=struct2cell(markersBoxS);

markerIndex1=find(strcmp(markerBoxC(2,:),['box' num2str(boxID) '_m1']));
markerIndex2=find(strcmp(markerBoxC(2,:),['box' num2str(boxID) '_m2']));

marker1=cell2mat(markerBoxC(1,markerIndex1));
marker2=cell2mat(markerBoxC(1,markerIndex2));
T=readtable(markersPath);
col1=marker1*3+2;
col2=marker2*3+2;
p1=table2array(T(frameID,col1:col1+2))';
p2=table2array(T(frameID,col2:col2+2))';

end

