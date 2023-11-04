function myPlotBoxContour(globalBoxes,sessionID,fc)
%MYPLOTBOXCONTOUR Plots the contour of planes that compose a set of
%detected boxes
%   Detailed explanation goes here
Nb=length(globalBoxes);
for i=1:Nb
    planeDescriptor=convertBoxIntoPlaneObject(globalBoxes(i),sessionID);
    for j=1:3
        myPlotPlaneContour(planeDescriptor(j),fc)
    end
end
end

