
% test 1. distance btwn 5-4, 5-13. Expected: around 0.2mt
plane1=myPlanes.fr5.values(4);
plane2=myPlanes.fr5.values(13);
d1 = measureGeomCenterBtwnPlanes(plane1,plane2)
% test 2. distance btwn 2-10, 4-3. Expected: near 0
plane1=myPlanes.fr2.values(10);
plane2=myPlanes.fr4.values(3);
d2 = measureGeomCenterBtwnPlanes(plane1,plane2)
% test 3. distance btwn 5-12, 5-11. Expected: 2mt aprox
plane1=myPlanes.fr5.values(12);
plane2=myPlanes.fr5.values(11);
d3 = measureGeomCenterBtwnPlanes(plane1,plane2)