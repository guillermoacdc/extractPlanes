function  myPlotPlanes_v2(myPlaneDescriptor, floorFlag, index)
%MYPLOTPLANES Summary of this function goes here
%   Detailed explanation goes here
% version for two dimensional index [v1 v2]; where v1 is the frame index
% and v2 is the plane index
% 

if nargin < 2
    floorFlag=true;
end

if nargin < 3
    myFieldName=fieldnames( myPlaneDescriptor );
    index=extractIDsFromVector(myPlaneDescriptor.(string(myFieldName)).values);
end
if floorFlag
    initIndex=1;
else
    initIndex=2;
end
for i=initIndex:1:size(index,1)
%     myPlotSinglePlane(myPlaneDescriptor{index(i)})
    frame_tp=index(i,1);
    element_tp=index(i,2);
    %     myPlotSinglePlane(myPlaneDescriptor.(['fr' num2str(frame_tp)])(element_tp),frame_tp)
%     myPlotSinglePlane(myPlaneDescriptor.(['fr' num2str(frame_tp)]).values(element_tp),frame_tp)
%     myPlotSinglePlane_v3(myPlaneDescriptor.(['fr' num2str(frame_tp)]).values(element_tp),frame_tp, frameFlag)
    myPlotSinglePlane_woutPK(myPlaneDescriptor.(['fr' num2str(frame_tp)]).values(element_tp), frame_tp, 'w');
end

view(2)
camup([0 1 0])
set(gcf,'color','k');
set(gca,'color','k');
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'

end

