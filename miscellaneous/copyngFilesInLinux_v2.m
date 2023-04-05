clc
close all
clear




sessionIDs=[13	15	16	17	18	19	20	21	25	27	32	33	35	36	39	45	52	53	54];
N=length(sessionIDs);

fileName='copyLinux.txt';
fileName2='boxByFrame.txt';

fileID = fopen(fileName,'a');
fmt='%s \n';
for i=1:N
    sessionID=sessionIDs(i);
%     /home/gacamacho/Documents/muelle6DViCuT/session13
    srcKt=['/home/gacamacho/Documents/muelle6DViCuT/session' num2str(sessionID)];
    sourceDataPath=fullfile(srcKt,fileName2);
% /home/gacamacho/Documents/6DViCuT_v1/session1
    destKt=['/home/gacamacho/Documents/6DViCuT_v1/session' num2str(sessionID)];
    destinationPath=fullfile(destKt,...
        'analyzed','HL2',fileName2);
    myCommand=['cp -R ' sourceDataPath ' ' destinationPath ];
    fprintf(fileID, fmt ,myCommand);
end
fclose(fileID);
