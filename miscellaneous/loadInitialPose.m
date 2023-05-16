function [initialPoses] = loadInitialPose(rootPath,scene,frame)
%LOADINITIALPOSE of boxes in the sequence boxID, r11, r12, r133,, px... pz
%   Detailed explanation goes here
% rootPath, - as rootpath
% scene, - as scene number
% frame, - as hololens frame where the initial pose is required. Note that
% the pose is function of the hololens frame. Some scenes have a first pose 
% at begining and a second pose (reposition) after a reference frame.
% Warning. The poses must be returned in the sequence of pps (physical packing seq)

% Assumption: The returned pose takes as reference a coordinate frame 
% located at the top plane of each box. Then for planetypes 2 and 3
% requires additional processing.


    % tform is available in the file rootPath/corridax/mocap/initialPose1.csv 
%    fileName=rootPath  + 'corrida' + num2str(scene) + '\mocap\initialPose1.csv';
%     fileName=rootPath  + 'session' + num2str(scene) + '/filtered/MoCap/sessionDescriptor.csv';
    fileName='sessionDescriptor.csv';
    filePath=fullfile(rootPath, ['session' num2str(scene)], 'filtered', 'MoCap');
    initialPosesT= readtable(fullfile(filePath,fileName));
    initialPosesA = table2array(initialPosesT);
    reposIndexes=findDuplicatedValues(initialPosesA(:,1));

    if isempty(reposIndexes)
        initialPoses=initialPosesA(:, [1 3:end]);
    else
        initialPosesRepos=initialPosesA(reposIndexes,:);
        initialPosesA(reposIndexes,:)=[];
        structRepos=array2PoseStruct(initialPosesRepos);
        N=length(structRepos);
        for i=1:N
            if(frame>=structRepos{i}.ref)
                initialPosesA=[initialPosesA; structRepos{i}.boxID structRepos{i}.ref structRepos{i}.secondPose];
            else
                initialPosesA=[initialPosesA; structRepos{i}.boxID 0 structRepos{i}.firstPose];
            end
        end
        initialPoses=initialPosesA(:,[1 3:end]);
        % sort in pps
        pps=getPPS(rootPath,scene);
        N=size(pps,1);
        for i=1:N
            ref=pps(i);
            sortIndex(i)=find(initialPoses(:,1)==ref);
        end
        initialPoses=initialPoses(sortIndex,:);
    end
%         update to return a dynamic number of boxes in function of the
%         frame number
boxByFrameA = loadBoxByFrame(rootPath,scene);
indexesBeforeFrame=computeIndexesBeforeFrame(boxByFrameA(:,3), frame);
initialPoses=initialPoses(indexesBeforeFrame:end,:);    
end

