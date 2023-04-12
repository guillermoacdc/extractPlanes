function myPlotSingleBox_v2(myPlaneDescriptor,boxes)
% _v2 uses the structure planesDescriptor with the fields (1) camerapose, (2) values

    frame_top   =boxes.planesID(1);
    element_top =boxes.planesID(2);
    frame_s1    =boxes.planesID(3);
    element_s1  =boxes.planesID(4);
    frame_s2    =boxes.planesID(5);
    element_s2  =boxes.planesID(6);

    myPlotSinglePlane(myPlaneDescriptor.(['fr' num2str(frame_top)]).values(element_top),frame_top);
%     myPlotSinglePlane_v3(myPlaneDescriptor.(['fr' num2str(frame_top)]).values(element_top),frame_top,true);
    hold on
%     myPlotSinglePlane(myPlaneDescriptor.(['fr' num2str(frame_s1)]).values(element_s1),frame_s1);
    myPlotSinglePlane_v3(myPlaneDescriptor.(['fr' num2str(frame_s1)]).values(element_s1),frame_s1,true);
    
    myPlotSinglePlane(myPlaneDescriptor.(['fr' num2str(frame_s2)]).values(element_s2),frame_s2);
