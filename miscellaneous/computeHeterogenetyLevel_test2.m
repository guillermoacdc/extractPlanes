clc
close all
clear


sessionsID=[ 3	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
Nsessions=size(sessionsID,2);
for i =1:Nsessions
    sessionID=sessionsID(i);
    dataSetPath=computeMainPaths(sessionID);
    keyframes=loadKeyFrames(dataSetPath,sessionID);
    Nkf=size(keyframes,2);
    heteroLevel_v=[];
    for j=1:Nkf
        heterogenityLevel  = computeHeterogenetyLevel(sessionID,keyframes(j));
        heteroLevel_v(j)=heterogenityLevel;
    end
    heteroLevel_mean(i)=mean(heteroLevel_v);
    heteroLevel_std(i)=std(heteroLevel_v);
end


[sessionsID' heteroLevel_mean' heteroLevel_std']   
  