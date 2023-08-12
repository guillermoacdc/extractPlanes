clc
close all
clear


sessionID=1;
    dataSetPath=computeMainPaths(sessionID);
    keyframes=loadKeyFrames(dataSetPath,sessionID);
    Nkf=size(keyframes,2);
    heteroLevel_v=[];
    for j=1:Nkf
        heterogenityLevel  = computeHeterogenetyLevel(sessionID,keyframes(j));
        heteroLevel_v(j)=heterogenityLevel;
    end


figure,

    stem(heteroLevel_v)
    xlabel 'frames'
    ylabel 'heterogeneity level'
    grid
    axis tight
