% test1. type of twin btwn 5-7, 2-3. Expected: 2
plane1=myPlanes.fr5.values(7);
plane2=myPlanes.fr2.values(3);
type1=computeTypeOfTwin(plane1,plane2)


% test2. type of twin btwn 4-6, 3-2. Expected: 1
plane1=myPlanes.fr4.values(6);
plane2=myPlanes.fr3.values(2);
type2=computeTypeOfTwin(plane1,plane2)


% test3. type of twin btwn 2-14, 3-7. Expected: 1
plane1=myPlanes.fr2.values(14);
plane2=myPlanes.fr3.values(7);
type3=computeTypeOfTwin(plane1,plane2)


% test4. type of twin btwn 5-10, 54-6. Expected: 0
plane1=myPlanes.fr5.values(10);
plane2=myPlanes.fr54.values(6);
type4=computeTypeOfTwin(plane1,plane2)


% test5. type of twin btwn 4-12, 54-3. Expected: 3
plane1=myPlanes.fr4.values(12);
plane2=myPlanes.fr54.values(3);
type5=computeTypeOfTwin(plane1,plane2)


% test6. type of twin btwn top planes 3-11, 2-11. Expected: 1
plane1=myPlanes.fr3.values(11);
plane2=myPlanes.fr2.values(11);
type6=computeTypeOfTwin(plane1,plane2)


% test7. type of twin btwn top planes 3-8, 2-9. Expected: 1
plane1=myPlanes.fr3.values(8);
plane2=myPlanes.fr2.values(9);
type7=computeTypeOfTwin(plane1,plane2)

% test8. type of twin btwn top planes 2-8, 5-11. Expected: 1
plane1=myPlanes.fr2.values(8);
plane2=myPlanes.fr5.values(11);
type8=computeTypeOfTwin(plane1,plane2)
figure
myPlotPlanes_v2(myPlanes, [2 8;5 11])


% test9. type of twin btwn top planes 2-9, 5-2. Expected: 1
plane1=myPlanes.fr2.values(9);
plane2=myPlanes.fr5.values(2);
type9=computeTypeOfTwin(plane1,plane2)
figure
myPlotPlanes_v2(myPlanes, [2 9;5 2])