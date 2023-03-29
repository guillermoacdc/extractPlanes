function estimatedPlanes_m = myProjectionPlaneObject(estimatedPlanes,frameID,sessionID,dataSetPath)
%MYPROJECTIONPLANEOBJECT Projects estimated poses of accepted planes to qm 
% and convert length to mm
% 
%   Detailed explanation goes here

estimatedPlanes_m=estimatedPlanes;
% get ID of accepted planes
estimatedPlanesID=estimatedPlanes.(['fr' num2str(frameID)]).acceptedPlanes;
Nep=size(estimatedPlanesID,1);
% load Th2m
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);
Theight=[0 1 0; 0 0 1; 1 0 0];
% Projection by using the Th2m matrix
for i=1:Nep
    estimatedPlaneID=estimatedPlanesID(i,2);
    estimatedPlane=estimatedPlanes.(['fr' num2str(frameID)]).values(estimatedPlaneID);
    Testimated=estimatedPlane.tform;%mt
    Testimated(1:3,4)=Testimated(1:3,4)*1000;%mm
    Testimated_m=Th2m*Testimated;
    %Requires an additional transformation to obtain the z-height in projected frame 
    Testimated_m(1:3,1:3)=Testimated_m(1:3,1:3)*Theight;
    estimatedPlanes_m.(['fr' num2str(frameID)]).values(estimatedPlaneID).tform=Testimated_m;
end



end

