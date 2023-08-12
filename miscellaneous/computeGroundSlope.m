clc
close all
clear 
% compara las alturas gt vs las altura reales de cada caja en la sesión.
% Asume que las sesiones no poseen apilamiento


sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
boxID=13;
frameID=10;
dataSetpath=computeMainPaths(sessionsID(1));

Ns=size(sessionsID,2);
cornerPointsB13=zeros(Ns*2,3);
k=1;
for j=1:Ns
    sessionID=sessionsID(j);
    [p1, p2]=loadMarkerPosition(sessionID,frameID, boxID);
    cornerPointsB13(k,:)=p1;
    cornerPointsB13(k+1,:)=p2;
    k=k+2;
end
% create point cloud
pc_box13=pointCloud(cornerPointsB13);

% fit a plane with RANSAC
maxDistance=2;
[model,inlierIndices,outlierIndices]=pcfitplane(pc_box13,maxDistance);
planeDescriptor.type=0;
planeDescriptor.L1=2500;
planeDescriptor.L2=6000;
tform=eye(4);
tform(1:3,3)=model.Normal';
tform(3,4)=abs(model.Parameters(4));
planeDescriptor.tform=tform;
T=eye(4);
alpha=computeAngleBtwnVectors([0 0 1],model.Normal');

figure,
    pcshow(pc_box13,"MarkerSize",15)
    hold on
    myPlotPlaneContour_qm(planeDescriptor, 'b')
    dibujarsistemaref(T,'m',150,2,10,'y')
    for k=1:size(outlierIndices,1)
        plot3(pc_box13.Location(outlierIndices(k),1),pc_box13.Location(outlierIndices(k),2),...
            pc_box13.Location(outlierIndices(k),3),'o')
    end
%     for k=1:size(pc_box13.Location,1)
%         plot3(pc_box13.Location(k,1),pc_box13.Location(k,2),...
%             pc_box13.Location(k,3),'o')
%     end

    title (['Plane slope computed from box 13. Angle=' num2str(alpha)])
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    
return
% Plot 



w = warning('query','last');
id=w.identifier;
warning('off',id)