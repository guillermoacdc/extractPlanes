function  myPlotPlanesv2(myPlaneDescriptor, index, in_SceneFolderPath)
%MYPLOTPLANES Summary of this function goes here
%   Detailed explanation goes here
% in_SceneFolderPath=['C:/lib/scene' num2str(scene) '/inputScenes/'];
pc_raw=pcread([in_SceneFolderPath + "frame" + num2str(myPlaneDescriptor{1}.idFrame) + ".ply"]);

T=eye(4);
for i=1:1:length(index)
%     pcshow(pc_raw)
%     hold on
    myPlotSinglePlanev2(myPlaneDescriptor{index(i)})
    hold on
    T(1:3,4)=myPlaneDescriptor{index(i)}.geometricCenter';
    dibujarsistemaref (T,0,0.5,1)%ref
end

view(2)
camup([0 1 0])
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'

end

