clc
close all 
clear

evalPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed\evalFolder';
datasetPath="G:\Mi unidad\boxesDatabaseSample\";
scene=13;
gtPose=loadInitialPose(datasetPath,scene,1);
boxesID=gtPose(:,1);
Nboxes=size(boxesID,1);
% verify if folder path exists
folderPath=[evalPath '\scene' num2str(scene) ];
folderExists=isfolder(folderPath);
if ~folderExists
    disp('the evaluation folder path does not exist');
    disp(folderPath)
    return
end

for i=1:Nboxes
    boxID=boxesID(i);
    filePath=[folderPath '\box' num2str(boxID) '.csv'];
    existFlag=exist(filePath, 'file');
%     verify if the filePath exists
    if ~existFlag
        disp('the file path does not exist');
        disp(filePath)
        continue
    end
    
    errorByFrame=readmatrix(filePath);
    
% display information in boxes where the eADD was different than zero in at
% least one frame
    sumeADD=sum(errorByFrame(:,4));
    if sumeADD~=0
        disp(['Box ' num2str(boxID)])
        frame=errorByFrame(:,1);
        eADDvalue=errorByFrame(:,4);
        T=table(frame,eADDvalue)
%         [errorByFrame(:,1) errorByFrame(:,4) ]
    end
end

