% test with polyshape class

% (0.067 -2.4873)    (0.51772 -2.5894)  (0.59592 -2.2449) (0.14578 -2.1427)  

pgon1 = polyshape([0.067 0.51772 0.59592 0.14578],[-2.4873 -2.5894 -2.2449 -2.1427]);
pgon2 = polyshape([0.086764 0.47118 0.41595 0.027414],[-2.4583 -2.3834 -2.1055 -2.1795]);
poly_intersection = intersect(pgon1,pgon2);
poly_union = union(pgon1,pgon2);
area_intersection=area(poly_intersection);
area_union = area(poly_union);
IoU=area_intersection/area_union;
figure,
plot(pgon1)
hold on
plot(pgon2)
title (['IoU= ' num2str(IoU)])
xlabel 'x'
ylabel 'z'
% figure,
% plot(poly_intersection)