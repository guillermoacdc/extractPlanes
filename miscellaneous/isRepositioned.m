function [reposFlag,reposFrame] = isRepositioned(rootPath,scene,boxID)
%ISREPOSITIONED Computes if a boxID from an scene was repositioned. If so,
%returns a true flag (reposFlag) and the HL2 frame where the reposition was
%performed

reposFlag=false;
reposFrame=0;

    % tform is available in the file rootPath/corridax/mocap/initialPose1.csv 
    fileName=rootPath  + 'corrida' + num2str(scene) + '\mocap\initialPose1.csv';
    initialPosesT= readtable(fileName);
    initialPosesA = table2array(initialPosesT);

    index=find(initialPosesA(:,1)==boxID);

    if length(index)>1
        reposFlag=true;
        reposFrame=initialPosesA(index(2),2);
    end


end

