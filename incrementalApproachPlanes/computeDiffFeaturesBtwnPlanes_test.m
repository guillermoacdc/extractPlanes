


id1=[20 5];
id2=[21 9];
[angleBtwnNormals, absDiffD, DistanceBtwnGC, DistanceBtwnGCh] = ...
    computeDiffFeaturesBtwnPlanes(globalPlanesPrevious,id1, ...
    globalPlanesPrevious, id2);

disp(['angleBtwnNormals = ' num2str(angleBtwnNormals) ])
disp(['absDiffD = ' num2str(absDiffD) ])
disp(['DistanceBtwnGC = ' num2str(DistanceBtwnGC) ])
disp(['DistanceBtwnGCh = ' num2str(DistanceBtwnGCh) ])


% id1=[26 6];
% id2=[27 6];
% angleBtwnNormals =    2.4196
% absDiffD =  135.8500
% DistanceBtwnGC =   43.1320
% ----
% id1=[26 5];
% id2=[25 2];
% angleBtwnNormals =    0.0652
% absDiffD =    0.4500
% DistanceBtwnGC =   98.9665
% -----
% id1=[13 10];
% id2=[13 11];
% angleBtwnNormals =11.92811         
% absDiffD =740.4      
% DistanceBtwnGC =261.0714
% ------
% id1=[19 4];
% id2=[20 5];
% angleBtwnNormals = 1.0006
% absDiffD = 14.4
% DistanceBtwnGC = 81.992
% --------
% id1=[20 5];
% id1=[21 9];
% angleBtwnNormals = 0.81189
% absDiffD = 8.71
% DistanceBtwnGC = 164.4273
