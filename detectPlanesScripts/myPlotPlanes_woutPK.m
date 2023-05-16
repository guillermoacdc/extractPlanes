function  myPlotPlanes_woutPK(myPlaneDescriptor)
%MYPLOTPLANES Summary of this function goes here
%   Detailed explanation goes here
% version for two dimensional index [v1 v2]; where v1 is the frame index
% and v2 is the plane index
% in_SceneFolderPath=['C:/lib/scene' num2str(scene) '/inputScenes/'];
% _v3: process a vector instead a struct

N=size(myPlaneDescriptor,2);
for i=1:N
    frame_tp=myPlaneDescriptor(i).idFrame;
    myPlotSinglePlane_woutPK(myPlaneDescriptor(i),frame_tp);
end

view(2)
camup([0 1 0])
set(gcf,'color','k');
set(gca,'color','k');
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'

end

