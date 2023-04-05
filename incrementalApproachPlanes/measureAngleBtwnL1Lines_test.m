

% test1. angleL1 btwn 5-7, 2-3. Expected: near 0
plane1=myPlanes.fr4.values(12);
plane2=myPlanes.fr54.values(3);
alfa1 = measureAngleBtwnL1Lines(plane1,plane2)
gc1=measureGeomCenterBtwnPlanes(plane1,plane2)
IoU1=measureIoUbtwnPlanes(plane1,plane2)

return

% test1. angleL1 btwn 5-7, 2-3. Expected: near 0
plane1=myPlanes.fr5.values(7);
plane2=myPlanes.fr2.values(3);
alfa1 = measureAngleBtwnL1Lines(plane1,plane2)
gc1=measureGeomCenterBtwnPlanes(plane1,plane2)
IoU1=measureIoUbtwnPlanes(plane1,plane2)

% test2. angleL1 btwn 4-12, 54-3. Expected: around 30
plane1=myPlanes.fr4.values(12);
plane2=myPlanes.fr54.values(3);
alfa2 = measureAngleBtwnL1Lines(plane1,plane2)

% test3. angleL1 btwn 2-14, 3-7. Expected: around 0
plane1=myPlanes.fr2.values(14);
plane2=myPlanes.fr3.values(7);
alfa3 = measureAngleBtwnL1Lines(plane1,plane2)