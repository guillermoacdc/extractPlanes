

% test1. IoU btwn 5-7, 2-3. Expected: near 0.35
plane1=myPlanes.fr5.values(7);
plane2=myPlanes.fr2.values(3);
IoU1 = measureIoUbtwnPlanes(plane1,plane2)


% test2. IoU btwn 4-6, 3-2. Expected: >=0.8
plane1=myPlanes.fr4.values(6);
plane2=myPlanes.fr3.values(2);
IoU2 = measureIoUbtwnPlanes(plane1,plane2)


% test3. IoU btwn 2-14, 3-7. Expected: >=0.8
plane1=myPlanes.fr2.values(14);
plane2=myPlanes.fr3.values(7);
IoU3 = measureIoUbtwnPlanes(plane1,plane2)

% test4. IoU btwn 54-6, 5-10. Expected: 0
plane1=myPlanes.fr54.values(6);
plane2=myPlanes.fr5.values(10);
IoU4 = measureIoUbtwnPlanes(plane1,plane2)

% test5. IoU btwn top planes 4-12, 54-3. Expected: >=0.3, <0.8
plane1=myPlanes.fr4.values(12);
plane2=myPlanes.fr54.values(3);
IoU5 = measureIoUbtwnPlanes(plane1,plane2)

% test6. IoU btwn top planes 4-12, 5-8. Expected: 0
plane1=myPlanes.fr4.values(12);
plane2=myPlanes.fr5.values(8);
IoU6 = measureIoUbtwnPlanes(plane1,plane2)
