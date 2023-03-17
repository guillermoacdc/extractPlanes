function initialPoses=loadInitialPose_v2(rootPath,scene, flagAdjustPose)
% This function loads the initial pose of boxes in an specific scene. The
% function assumes the existence of a file called initialPoseBoxes.csv in
% the rootPath/

    % tform is available in the file rootPath/scenex/Mocap_initialPoseBoxes.csv 
%     fileName=rootPath  + 'scene' + num2str(scene) + '\initialPoseBoxes.csv';
    fileName=rootPath  + 'corrida' + num2str(scene) + '\mocap\initialPose1.csv';

    initialPosesT= readtable(fileName);
    initialPosesA = table2array(initialPosesT);
%     requires a 90deg rotation around z
Trot90=eye(4);
Trot90(1:3,1:3)=rotz(90);
Trot180=eye(4);
Trot180(1:3,1:3)=rotz(180);

if (flagAdjustPose)
    for i=1:size(initialPosesA,1)
        T=initialPosesA(i,3:end);
        T1=assemblyTmatrix(T);
        T2=T1*Trot90;
        angle=computeAngleBtwnVectors([1 0 0]',[T2(1:3,1)]);%angle btwn x axis
        if angle>=90 | angle<=-90
            T2=T2*Trot180;
        end
%         disp(['angle btwn box ' num2str(initialPosesA(i,1)) ' and mocap x frame: ' num2str(angle) ])
        initialPosesA(i,3:end)=[T2(1,[1:4]) T2(2,[1:4]) T2(3,[1:4])];
    end
end
    initialPoses=initialPosesA(:,[1 3:end]);
%     display(initialPosesA(i,1) )
%     display( initialPosesA(i,2:end))
end


