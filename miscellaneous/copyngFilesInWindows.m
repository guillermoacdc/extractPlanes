clc
close all
clear




sessionIDs=[13	15	16	17	18	19	20	21	25	27	32	33	35	36	39	45	52	53	54];
% G:\Mi unidad\semestre 9\HighOcclusionScenes_processed
% sessionIDs=[15 16 18 21];
N=length(sessionIDs);


fileName='copyWindows2.txt';
fileNameInDestination='markerPosition.c3d';

fileID = fopen(fileName,'a');
fmt='%s \n';
for i=1:N
    sessionID=sessionIDs(i);
    app=computeAppendMocapFileName(sessionID);
    fileNameInSource=['corrida' num2str(sessionID) '-00' num2str(app) '.c3d'];
    
    sourceDataPath=fullfile(['G:\"Mi unidad"\boxesDatabaseSample\corrida' num2str(sessionID)],...
        'mocap',fileNameInSource);

%     sourceDataPath=fullfile(['G:\"Mi unidad"\"semestre 9"\HighOcclusionScenes_processed'],...
%         ['corrida' num2str(sessionID)]);

    destinationPath=fullfile(['D:\muelle6DViCuT\session' num2str(sessionID)], fileNameInDestination);
    myCommand=['copy ' sourceDataPath ' ' destinationPath ];
    fprintf(fileID, fmt ,myCommand);
end
fclose(fileID);
