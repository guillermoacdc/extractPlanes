function [dataSetPath,evalPath,PCpath] = computeMainPaths(sessionID)
%COMPUTEMAINPATHS Summary of this function goes here
%   Detailed explanation goes here


typeOfSession=computeTypeOfSession(sessionID);%1 low occ, 2 med occ, 3 high occ
f=filesep;
if (f=='/')%linux
    evalPath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/evalFolder';
    dataSetPath="/home/gacamacho/Documents/6DViCuT_v1/";
    
    switch (typeOfSession)
        case 1
            PCpath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/lowOcclusionScenes_processed';
        case 2
            PCpath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/MediumOcclusionScenes_processed';
        case 3
            PCpath='/home/gacamacho/Documents/PCs_extractedPlanes_v1/HighOcclusionScenes_processed';
    end
else %windows
%     evalPath='G:\Mi unidad\pruebasUbuntu\evalFolder';
%     evalPath='G:\Mi unidad\pruebasUbuntu\evalFolder_dmax\evalFolder_dmax3860';
%     evalPath='D:\doctorado\evalFolder';
%     evalPath='D:\OneDriveUnisalle\OneDrive - correounivalle.edu.co\pruebasUbuntu\evalFolder_dmax\evalFolder_dmax3860';
    evalPath='D:\OneDriveUnisalle\OneDrive - correounivalle.edu.co\pruebasUbuntu\evalFolder';
    dataSetPath='D:\6DViCuT_p1';
    
    switch (typeOfSession)
        case 1
%             PCpath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed';
            PCpath='D:\6DViCuT_p1\processedPCs\lowOcclusionScenes_processed';
        case 2
            PCpath='D:\6DViCuT_p1\processedPCs\MediumOcclusionScenes_processed';
        case 3
            PCpath='D:\6DViCuT_p1\processedPCs\HighOcclusionScenes_processed';
    end
    
end



end

