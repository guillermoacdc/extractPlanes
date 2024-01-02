function recordDescriptors(dataSetPath, sessionID, frameID, globalPlanes,...
    localPlanes,filePath)
%RECORDDESCRIPTORS Records four descriptors for each iteration at
%myPlaneTracker:
% 1. gps(k).fig: figure of global map plane segments
% 2. lps(k).fig: figure of local map plane segments
% 3. fgps(k).xlsx: excel book with descriptors of fitness at global map plane segments
% 4. lps(k).xlsx: excel book with descriptors of fitness at local map plane segments



%% create folder
    % save the current path
    currentcd=pwd;
    % go to save filepath 
    cd (filePath);
    % create folder
    folderName=['session' num2str(sessionID)];
    folderExists=isfolder(folderName);
    if ~folderExists
        mkdir (folderName);
    end
    % return to saved path
    cd (currentcd);

%% set file names
    fileName1=['gps(' num2str(frameID) ')'];
    fileName2=['lps(' num2str(frameID) ')'];
    fileName3=['Quality_gps(' num2str(frameID) ').xls'];
    fileName4=['Quality_lps(' num2str(frameID) ').xls'];
%% create and save images
    % global planes
    figure,
    syntheticPlaneType=4;
    plotEstimationsByFrame_vcuboids_2(globalPlanes.values,syntheticPlaneType,...
        dataSetPath,sessionID,frameID)
        title(['global planes  in frame ' num2str(frameID-1)])
    saveas(gcf,fullfile(filePath, folderName, fileName1));
    
    % local planes
    figure,
        myPlotPlanes_v3(localPlanes.values,1);
        title(['local planes  in frame ' num2str(frameID-1)])
        saveas(gcf,fullfile(filePath, folderName, fileName2));
%% create and save descriptors in excel
    getFitnessMetrics(globalPlanes.values, fullfile(filePath, folderName, fileName3))
    getFitnessMetrics(localPlanes.values, fullfile(filePath, folderName, fileName4))
end

