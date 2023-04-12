function myPlotScannedPCs(globalPlanes_m,dataSetPath,sessionID)
%MYPLOTSCANNEDPCS Summary of this function goes here
%   Detailed explanation goes here
Ngp=size(globalPlanes_m,2);
for i=1:Ngp 
    mypcshow(globalPlanes_m(i),dataSetPath,sessionID);
    hold on
    T=globalPlanes_m(i).tform;
    label=globalPlanes_m(i).getID;
    dibujarsistemaref(T,label,150,2,10,'w');
end
% dibujarsistemaref(eye(4),'m',150,2,10,'w')
xlabel 'x'
ylabel 'y'
zlabel 'z'
grid
end

