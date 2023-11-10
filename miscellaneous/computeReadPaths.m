function [dataSetPath,PCpath] = computeReadPaths(sessionID)
%COMPUTEMAINPATHS load paths to read and write data
%   dataSetPath: read path. Points to folder 6D_ViCuT as published in the paper
%   xxx
%   evalPath: read and write path. Points to folder evalFolder_app where
%   app is a complement to control different versions of experiments. This
%   folder has one subfolder for each processed session. Each folder
%   contains the results of the (1) estimations and (2) assessment of
%   estimations. Additionally, has a subfolder with name session0. This one
%   contains the mean metrics assessment for the whole dataset. 
%   PCpath: read path. path with folder lowOcclusionScenes_processed. This
%   folder contains one subfolder for each session. Each subfolder contains
%   one subfolder for each processed frame. Each subfolder contains ply
%   files of detected planes by frame and log files with plane parameters,
%   used parameters


typeOfSession=computeTypeOfSession(sessionID);%1 low occ, 2 med occ, 3 high occ
f=filesep;
if (f=='/')%linux

    dataSetPath="/home/gacamacho/Documents/6DViCuT_v1/";
    
    switch (typeOfSession)
        case 1
            PCpath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/lowOcclusionScenes_processed_d5';
        case 2
            PCpath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/MediumOcclusionScenes_processed';
        case 3
            PCpath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/HighOcclusionScenes_processed';
    end
else %windows

    dataSetPath='D:\sixDViCuT_p1';
    
    switch (typeOfSession)
        case 1
%             PCpath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
            PCpath='D:\sixDViCuT_p1\processedPCs\lowOcclusionScenes_processed';
        case 2
            PCpath='D:\sixDViCuT_p1\processedPCs\MediumOcclusionScenes_processed';
        case 3
            PCpath='D:\sixDViCuT_p1\processedPCs\HighOcclusionScenes_processed';
    end
    
end



end

