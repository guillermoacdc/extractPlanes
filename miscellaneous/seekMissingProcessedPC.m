clc
close all
clear

% set parameters
datasetPath='G:\Mi unidad\boxesDatabaseSample\';
typeOfScenes=1;% (1) for low occlussion, (2) for medium occlusion, (3) for high occlusion
switch(typeOfScenes)
   case 1 
      fprintf('Low Occlussion Dataset\n' );
      processedDataPath='G:\Mi unidad\semestre 9\lowOcclusionScenes_processed\';
      scenes=[3 10 12 13 17 19 20 25 27 32 33 35 36 39 45 52 53 54 ];
   case 2 
      fprintf('Medium Occlussion Dataset\n' );
      processedDataPath='G:\Mi unidad\semestre 9\MediumOcclusionScenes_processed\';
      scenes=[1 2 4 5 6 7 ];
   case 3 
      fprintf('High Occlussion Dataset\n' );
      processedDataPath='G:\Mi unidad\semestre 9\HighOcclusionScenes_processed\';
      scenes=[15 16 18 21];
   otherwise
      fprintf('Invalid type of scene\n' );
end


M=length(scenes);
for j=1:M
    scene=scenes(j);
    disp(['At scene ' num2str(scene)])
    % load keyframes of the scene
    keyFrames=loadKeyFrames(convertCharsToStrings(datasetPath),scene);
    N=length(keyFrames);
    % iterative process
    for i=1:N
        frame=keyFrames(i);
        folderName=[processedDataPath 'corrida' num2str(scene) '\frame' num2str(frame)];
        flagExist=isfolder(folderName);
        if ~flagExist
            disp(['          Frame ' num2str(frame) ' is missing']);
        end
    end
end