clc
close all
clear 

estimatedLength=[801.2903 434.1727 201.0872];% [width, depth, height]
% load previous knowledge of size and ID of box
sessionID=10;
frameID=24;
dataSetPath=computeReadPaths(sessionID);
pps = getPPS(dataSetPath,sessionID, frameID);
parameters =loadLengths_v2(dataSetPath,pps);%boxID H, W, D in mm
% reorder lengths to complain id, width, depth, height
searchSpace=parameters(:,[1,3,4,2]);
Nb=size(parameters,1);
distanceVector=zeros(Nb,1);
% compute distance
for i=1:Nb
    distanceVector(i)=norm(searchSpace(i,[2:4])-estimatedLength);
end
[minDistance, index]=min(distanceVector);
boxID=searchSpace(index,1)

% plot search space and estimated Length

for i=1:Nb
    x=searchSpace(i,2);
    y=searchSpace(i,3);
    z=searchSpace(i,4);
    plot3(x,y,z,'ro')
    hold on
    text(x,y,z,num2str(searchSpace(i,1)))
end
plot3(estimatedLength(1), estimatedLength(2), estimatedLength(3), 'b*')
grid on
xlabel 'width'
ylabel 'depth'
zlabel 'height'