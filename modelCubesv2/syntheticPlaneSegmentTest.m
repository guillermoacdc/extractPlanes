figure,
myPlotPlanes_v3(globalPlanes.values(3),1)
hold on
myPlotPlanes_v3(globalPlanes.values(7),1)

origin_top=globalPlanes.values(3).tform(1:3,4);
zcomp_top=globalPlanes.values(3).tform(1:3,3);
Lb_top=globalPlanes.values(3).L2/2;
q1_pos=origin_top+zcomp_top*Lb_top;

plot3(q1_pos(1),q1_pos(2),q1_pos(3),'yo')

ycomp_perp=globalPlanes.values(7).tform(1:3,2);
Lb_perp=globalPlanes.values(7).L1;
q1_pos2=q1_pos-Lb_perp/2*ycomp_perp;
plot3(q1_pos2(1),q1_pos2(2),q1_pos2(3),'yo')