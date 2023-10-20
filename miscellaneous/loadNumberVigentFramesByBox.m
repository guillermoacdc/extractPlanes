function nvfbb = loadNumberVigentFramesByBox(sessionID)
%LOADNUMBERVIGENTFRAMESBYBOX loads number of vigent frames by box (nvfbb)
%   Detailed explanation goes here
datasetPath=computeReadPaths(sessionID);
boxByFrameA=loadBoxByFrame(datasetPath,sessionID);
Nb=size(boxByFrameA,1);
nvfbb=zeros(Nb,1);
keyFrames=loadKeyFrames(datasetPath,sessionID);
for i=1:Nb
    initFrame=boxByFrameA(i,2);
    endFrame=boxByFrameA(i,3);
    kf1=find(keyFrames<endFrame);
    kf2=find(keyFrames<initFrame);
    nvfbb(i)=length(kf1)-length(kf2)+1;
    if i>1
        nvfbb(i)=nvfbb(i)+nvfbb(i-1);
    end
end

end

