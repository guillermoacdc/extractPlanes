clc
close all
clear
% computes and saves visible planes in the global scope. Uses an accumulative approach
% the saved file is an structure with fields
% framex
% . boxID
% . planeID
dataSetPath = computeReadPaths(1);
% sessionsID=[ 3 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=10;
Ns=length(sessionsID);
for j=1:Ns
    sessionID=sessionsID(j);
    filePath=fullfile(dataSetPath,['session' num2str(sessionID)], 'analyzed','HL2');
    keyframes=loadKeyFrames(dataSetPath,sessionID);
    N=length(keyframes);
    visiblePlanesFileName='visiblePlanesByFrame.json';
    outputFileName='globalVisiblePlanesByFrame';
    for i=1:N
        
        frameID=keyframes(i);
        disp(['processing frame ' num2str(frameID)])
        if frameID==143
            disp('stop mark')
        end
        visible_lps_vector=loadVisiblePlanesVector(visiblePlanesFileName, sessionID,...
            frameID);
    % loadVisiblePlanesVector
        if i~=1
    %         compute visible gps vector
            %     accumulate ids
            accIDs=[visible_gps_vector_previous; visible_lps_vector];
            %   compute unique values
            mergedIDs=myUnique2D(accIDs);
            % delete extracted boxes
            extractedBoxesID = computeExtractedBoxes(sessionID, frameID);
            visible_gps_vector = updateGlobalVisiblePlanes(mergedIDs,extractedBoxesID);
    %         visible_gps_vector=mergedIDs;
        else
            visible_gps_vector=visible_lps_vector;
        end
        visible_gps_vector_previous=visible_gps_vector;
    %% convert vector to structure
        globalVisiblePlanesByFrame_s = convert2DVtoStructV(visible_gps_vector);
        globalVisiblePlanesBySession.(['frame' num2str(frameID)])=globalVisiblePlanesByFrame_s ;
    end
    %save structure to disk
    encoded=jsonencode(globalVisiblePlanesBySession,PrettyPrint=true);
    cd(filePath);
    fid = fopen([outputFileName '.json'],'w');
    fprintf(fid,'%s',encoded);
    fclose(fid);
end


