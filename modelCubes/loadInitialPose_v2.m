function initialPoses=loadInitialPose_v2(rootPath,scene)
% This function loads the initial pose of boxes in an specific scene. The
% function assumes the existence of a file called initialPoseBoxes.csv in
% the rootPath/

    % tform is available in the file rootPath/scenex/Mocap_initialPoseBoxes.csv 
    fileName=rootPath  + 'scene' + num2str(scene) + '\initialPoseBoxes.csv';
    initialPosesT= readtable(fileName);
    initialPosesA = table2array(initialPosesT);
%     requires a 90deg rotation around z
Trot=eye(4);
Trot(1:3,1:3)=rotz(90);
for i=1:size(initialPosesA,1)
    T=initialPosesA(i,3:end);
    T1=assemblyTmatrix(T);
    T2=T1*Trot;
    initialPosesA(i,3:end)=[T2(1,[1:4]) T2(2,[1:4]) T2(3,[1:4])];
end

    initialPoses=initialPosesA(:,[1 3:end]);
end