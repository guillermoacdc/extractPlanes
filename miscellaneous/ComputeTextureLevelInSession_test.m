clc
close all
clear

sessionsID=[ 3	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
Nsessions=size(sessionsID,2);

for i =1:Nsessions
    sessionID=sessionsID(i);
    [textureLevel, higTextureFraction]=ComputeTextureLevelInSession(sessionID,2);
    textureLevel_v(i)=textureLevel;
    higTextureFraction_v(i)=higTextureFraction;
end

[sessionsID' higTextureFraction_v']
