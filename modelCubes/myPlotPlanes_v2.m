function  myPlotPlanes_v2(myPlaneDescriptor, index, in_SceneFolderPath)
%MYPLOTPLANES Summary of this function goes here
%   Detailed explanation goes here
% version for two dimensional index [v1 v2]; where v1 is the frame index
% and v2 is the plane index
% in_SceneFolderPath=['C:/lib/scene' num2str(scene) '/inputScenes/'];

for i=1:1:size(index,1)
%     myPlotSinglePlane(myPlaneDescriptor{index(i)})
frame_tp=index(i,1);
element_tp=index(i,2);
    myPlotSinglePlane(myPlaneDescriptor.(['fr' num2str(frame_tp)])(element_tp),frame_tp)
end

view(2)
camup([0 1 0])
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'

end

