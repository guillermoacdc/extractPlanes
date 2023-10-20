function [evalPath] = computeReadWritePaths(app)
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



f=filesep;
if (f=='/')%linux
    evalPath=['/home/gacamacho/Documents/PCs_extractedPlanes_v1/evalFolder' app];
else %windows
    evalPath=['D:\OneDriveUnisalle\OneDrive - correounivalle.edu.co\pruebasUbuntu\evalFolder' app];
end

end

