function myPlotEstimatedBox(globalPlanes,globalBoxes)

Nb=length(globalBoxes);
figure,
for i=1:Nb
    topIndex=globalBoxes(i).planesID(1);
    perpIndex1=globalBoxes(i).planesID(2);
    perpIndex2=globalBoxes(i).planesID(3);
    myPlotPlanes_v3(globalPlanes.values(topIndex),1);
    hold on
    myPlotPlanes_v3(globalPlanes.values(perpIndex1),1);
    myPlotPlanes_v3(globalPlanes.values(perpIndex2),1);
end

end