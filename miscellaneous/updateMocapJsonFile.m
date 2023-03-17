function [updateMoCapDescriptors] = updateMocapJsonFile(sessionID,markerIDPath,MoCapDescriptors)
%UPDATEMOCAPJSONFILE Performs the update indicated in this video
% https://drive.google.com/open?id=1s8gpsAYvD2_4ONZqaMfVujoqsfMlvdqX&authuser=guillermo.camacho%40correounivalle.edu.co&usp=drive_fs
%   Detailed explanation goes here
updateMoCapDescriptors=MoCapDescriptors;
updateMoCapDescriptors.trackers.id=sessionID;
mBoxes=loadMarkerBoxes(markerIDPath,sessionID);
N=size(mBoxes,1);
for i=1:N
    boxID=mBoxes(i,3);
    m1=mBoxes(i,1);
    m2=mBoxes(i,2);
    markerName=['box' num2str(boxID)];
    updateMoCapDescriptors.trackers.markers(m1+1).name=[markerName '_m1'];
    updateMoCapDescriptors.trackers.markers(m2+1).name=[markerName '_m2'];
end

mHL2=[0 3 4 5 6];
for i=1:length(mHL2)
    updateMoCapDescriptors.trackers.markers(mHL2(i)+1).name='HL2';
end

end

