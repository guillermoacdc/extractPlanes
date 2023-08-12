clc
close all
clear

sessionsID=[ 3	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
% sessionsID=[ 33		];% 
Nsessions=size(sessionsID,2);

for i =1:Nsessions
    sessionID=sessionsID(i);
%     if sessionID==33
%         disp('stop')
%     end
    dataSetPath=computeMainPaths(sessionID);
    keyframes=loadKeyFrames(dataSetPath,sessionID);
    Nkf=size(keyframes,2);
    textureLevel_v=[];
    for j=1:Nkf
        textureLevel=ComputeTextureLevelInSession(sessionID,keyframes(j));
        textureLevel_v(j)=textureLevel;
%         higTextureFraction_v(i)=higTextureFraction;
    end
    textureLevel_mean(i)=mean(textureLevel_v);
    textureLevel_std(i)=std(textureLevel_v);
end



figure,
    stem(textureLevel_v)
    xlabel 'frames'
    ylabel 'texture level in session'
    grid

[sessionsID' textureLevel_mean' textureLevel_std']    