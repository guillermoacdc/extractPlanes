function estimatedPlanes_m = myProjectionPlaneObject_v2(estimatedPlanes,sessionID,dataSetPath)
%MYPROJECTIONPLANEOBJECT Projects estimated poses of accepted planes to qm 
% 
% 
%   Detailed explanation goes here

estimatedPlanes_m=estimatedPlanes;
Nep=size(estimatedPlanes,2);
% load Th2m
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);
Theight=[0 1 0; 0 0 1; 1 0 0];
% Projection by using the Th2m matrix
for i=1:Nep
    estimatedPlane=estimatedPlanes(i);
    Testimated=estimatedPlane.tform;%mt
    Testimated_m=Th2m*Testimated;
    %Requires an additional transformation to obtain the z-height in projected frame 
    Testimated_m(1:3,1:3)=Testimated_m(1:3,1:3)*Theight;
    estimatedPlanes_m(i).tform=Testimated_m;
end



end

