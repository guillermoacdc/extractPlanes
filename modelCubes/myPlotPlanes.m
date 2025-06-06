function  myPlotPlanes(myPlaneDescriptor, index, in_SceneFolderPath)
%MYPLOTPLANES Summary of this function goes here
%   Detailed explanation goes here
% in_SceneFolderPath=['C:/lib/scene' num2str(scene) '/inputScenes/'];
pc_raw=pcread([in_SceneFolderPath + "frame" + num2str(myPlaneDescriptor{1}.idFrame) + ".ply"]);

for i=1:1:length(index)
%     myPlotSinglePlane(myPlaneDescriptor{index(i)})
    myPlotSinglePlane(myPlaneDescriptor{index(i)},myPlaneDescriptor{index(i)}.idFrame)
end

view(2)
camup([0 1 0])
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'

end

