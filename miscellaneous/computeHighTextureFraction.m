function [highTxtFraction] = computeHighTextureFraction(sessionID,frameID)
%COMPUTEHIGTEXTUREFRACTION Summary of this function goes here
%   Called by ComputeTextureLevelInSession()

dataSetPath=computeMainPaths(sessionID);
pps=getPPS(dataSetPath, sessionID, frameID);
Npps=size(pps,1);
accHighTxt=0;
for i=1:Npps
    if pps(i)>=21 & pps(i)<=29
        accHighTxt=accHighTxt+1;
    end
end

highTxtFraction=accHighTxt*100/Npps;
end

