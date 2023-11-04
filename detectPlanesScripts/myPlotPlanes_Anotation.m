function  myPlotPlanes_Anotation(myPlaneDescriptor, frameFlag, worldRef)
%MYPLOTPLANES Summary of this function goes here
%   Detailed explanation goes here
% version for two dimensional index [v1 v2]; where v1 is the frame index
% and v2 is the plane index
% in_SceneFolderPath=['C:/lib/scene' num2str(scene) '/inputScenes/'];
% _v3: process a vector instead a struct
% worldRef={'m', 'h'}
% N=size(myPlaneDescriptor,2);
N=length(myPlaneDescriptor);
for i=1:N
    frame_tp=myPlaneDescriptor(i).idFrame;
    if worldRef=='h'
        myPlotSinglePlane_Anotation(myPlaneDescriptor(i),frame_tp,...
        frameFlag);%to plot in qh world
    else
        myPlotPlaneContour_qm(myPlaneDescriptor(i),'w', frameFlag);%to plot in qm world
    end
end

view(2)
camup([0 1 0])
set(gcf,'color','k');
set(gca,'color','k');
% xlabel 'x (m)'
% ylabel 'y (m)'
% zlabel 'z (m)'

end

