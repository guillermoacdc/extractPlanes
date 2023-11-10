function myPlotBoxContour_v2(globalBoxes,sessionID,frameID,fc)
%MYPLOTBOXCONTOUR Plots the contour of planes that compose a set of
%detected boxes
% _v2 adds to the plot the ground truth boxes in the scene
%   Detailed explanation goes here
%% plot ground truth boxes
dataSetPath=computeReadPaths(sessionID);
boxID=getPPS(dataSetPath,sessionID,frameID);
Nb=length(boxID);

% compute Tm2h
Th2m=loadTh2m(dataSetPath,sessionID);
Tm2h=inv(Th2m);

% sidesVector=[1:5];
% sidesVector=[1 2 5; 1 3 4; 1 4 5; 1 4 5; 1 4 5; 1 2 5];
sidesVector=repmat(1:5,Nb,1);

NpointsDiagTopSide=10;
gridStep=1;
% load descriptors of planes that compose boxID
for i=1:Nb
    planeDescriptor{i} = convertPK2PlaneObjects_v5(boxID(i),sessionID, ...
    sidesVector(i,:), frameID);
    % project poses
    planeDescriptor{i}=projectPose(planeDescriptor{i},Tm2h);
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
    myPlotPlanes_Anotation(planeDescriptor{i},0,'m')
   hold on
end    
%% plot global boxes
myPlotBoxContour(globalBoxes,sessionID,fc)
dibujarsistemaref(eye(4),'h',250,2,10,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid on
title 'test on generate synthetic point cloud'

end

