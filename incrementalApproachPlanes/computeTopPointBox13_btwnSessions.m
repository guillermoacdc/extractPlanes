clc
close all
clear 
% compara las alturas gt vs las altura reales de cada caja en la sesión.
% Asume que las sesiones no poseen apilamiento


% sessionsID=[ 3	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
% sessionsID=[ 32 ];

Ns=size(sessionsID,2);
deviationHeightBySession=zeros(Ns,1);
meanDeviationHeightBySession=zeros(Ns,1);
stdDeviationHeightBySession=zeros(Ns,1);
frameID=1;
syntheticPlaneType=0;
topPoint=zeros(Ns,3);
for j=1:Ns
    sessionID=sessionsID(j);
    dataSetPath=computeMainPaths(sessionID);
    gtPlanes=loadInitialPose_v3(dataSetPath,sessionID,frameID,syntheticPlaneType);
    
    N=size(gtPlanes,2);%number of boxes
    boxID=zeros(N,1);

    for i=1:N
        if gtPlanes(i).idBox==13
            topPoint(j,:)=[gtPlanes(i).tform(1,4), gtPlanes(i).tform(2,4),...
                gtPlanes(i).tform(3,4)];
        end
    end
end
% create point cloud
pc_box13=pointCloud(topPoint);

% fit a plane with RANSAC
maxDistance=5;
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
    title (['Plane slope computed from box 13. Angle=' num2str(alpha)])
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    
return
% Plot 


return
w = warning('query','last');
id=w.identifier;
warning('off',id)