function targetChannel_interpolated=manageRigidInterpByChannel(targetChannel, markerID, channelRef,nmbFrames,rootPath,scene)
targetChannel_interpolated=targetChannel;
for i=1:nmbFrames
    if isnan(targetChannel(i,1))
        targetChannel_interpolated(i,:)=rigidInterpBySample(markerID,channelRef(i,:),rootPath,scene);
    end
end
end

