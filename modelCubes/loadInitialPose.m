function initialPoses=loadInitialPose(rootPath,scene)
% This function loads the initial pose of boxes in an specific scene. The
% function assumes the existence of a file called initialPoseBoxes.csv in
% the rootPath/

    % tform is available in the file rootPath/scenex/Mocap_initialPoseBoxes.csv 
    fileName=rootPath  + 'scene' + num2str(scene) + '\initialPoseBoxes.csv';
    initialPosesT= readtable(fileName);
    initialPosesA = table2array(initialPosesT);
    initialPoses=initialPosesA(:,[1 3:end]);
end