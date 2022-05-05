function myPlotSingleBox(myPlaneDescriptor,boxes)


    frame_top   =boxes.planesID(1);
    element_top =boxes.planesID(2);
    frame_s1    =boxes.planesID(3);
    element_s1  =boxes.planesID(4);
    frame_s2    =boxes.planesID(5);
    element_s2  =boxes.planesID(6);

    myPlotSinglePlane(myPlaneDescriptor.(['fr' num2str(frame_top)])(element_top),frame_top);
    hold on
    myPlotSinglePlane(myPlaneDescriptor.(['fr' num2str(frame_s1)])(element_s1),frame_s1);
    myPlotSinglePlane(myPlaneDescriptor.(['fr' num2str(frame_s2)])(element_s2),frame_s2);
