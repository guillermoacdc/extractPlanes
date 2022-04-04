function  myPlotPlanes(myPlaneDescriptor, index, in_SceneFolderPath)
%MYPLOTPLANES Summary of this function goes here
%   Detailed explanation goes here
% in_SceneFolderPath=['C:/lib/scene' num2str(scene) '/inputScenes/'];
pc_raw=pcread([in_SceneFolderPath + "frame" + num2str(myPlaneDescriptor{1}.idFrame) + ".ply"]);


for i=1:1:length(index)
%     pcshow(pc_raw)
%     hold on
    myPlotSinglePlane(myPlaneDescriptor{index(i)})
    hold on


end    
view(2)
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'

end

