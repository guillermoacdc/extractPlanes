function [textureLevel, higTextureFraction] = ComputeTextureLevelInSession(sessionID,frameID)
%COMPUTETEXTURELEVELINSESSION Summary of this function goes here
%   Detailed explanation goes here
higTextureFraction=computeHighTextureFraction(sessionID, frameID);
if higTextureFraction==0
    textureLevel=1;
else
    if higTextureFraction<14
        textureLevel=2;
    else 
        textureLevel=3;
    end

end

end

