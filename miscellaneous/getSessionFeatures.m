clc
close all
clear 


sessionID=54;
dataSetPath=computeMainPaths(sessionID);
frameID=1;
pps = getPPS(dataSetPath,sessionID,frameID);
Nb=size(pps,1);
acchighTextureFlag=0;
acchighSizeFlag=0;
accnewBoxFlag=0;
for i=1:Nb
    boxID=pps(i);
    [highTextureFlag, highSizeFlag, newBoxFlag]=computeBoxFeatureFlag(boxID);
    if highTextureFlag==1
        acchighTextureFlag=acchighTextureFlag+1;
    end
    if highSizeFlag==1
        acchighSizeFlag=acchighSizeFlag+1;
    end
    if newBoxFlag==1
        accnewBoxFlag=accnewBoxFlag+1;
    end
end
[acchighTextureFlag, acchighSizeFlag, accnewBoxFlag]