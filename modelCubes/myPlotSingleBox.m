function myPlotSingleBox(planeDescriptor,boxes,i)

myPlotSinglePlane(planeDescriptor{boxes.side1PlaneID},i)
hold on
myPlotSinglePlane(planeDescriptor{boxes.side2PlaneID},i)
myPlotSinglePlane(planeDescriptor{boxes.topPlaneID},i)
