function myPlotBoxes(myBoxes, sessionID, lineColor)
%MYPLOTBOXES Summary of this function goes here
%   Detailed explanation goes here
frameID=0;%update
boxID=extractIDsFromBoxVector(myBoxes);
Nb=length(boxID);
dataSetPath=computeReadPaths(sessionID);
% sidesVector=[1:5];
% sidesVector=[1 2 5; 1 3 4; 1 4 5; 1 4 5; 1 4 5; 1 2 5];
sidesVector=repmat(1:5,Nb,1);

NpointsDiagTopSide=10;
gridStep=1;
% load descriptors of planes that compose boxID
for i=1:Nb
    planeDescriptor{i} = convertBox2PlaneObjects(myBoxes(i),sessionID, ...
    sidesVector(i,:), frameID);
    % project poses
%     planeDescriptor{i}=projectPose(planeDescriptor{i},Tm2h);
end
% create synthetic PC
for i=1:Nb
    pc{i}=createSyntheticPC_v2(planeDescriptor{i},NpointsDiagTopSide,boxID(i), gridStep, dataSetPath);
end

for i=1:Nb
    pcshow(pc{i})
    hold on
    dibujarsistemaref(planeDescriptor{i}(1).tform,boxID(i),150,2,10,'w');
    hold on
    myPlotPlanes_Anotation(planeDescriptor{i},0,'m', lineColor)
   hold on
end    

end

