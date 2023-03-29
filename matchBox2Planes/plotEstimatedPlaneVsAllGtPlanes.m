function plotEstimatedPlaneVsAllGtPlanes(estimatedPlane,dataSetPath,...
    sessionID,eADD_m, spatialSampling, boxID)

% estimatedPose,dataSetPath,...
%     sessionID, boxID, pathPCScanned

% plotEstimatedPlaneVsAllGtPlanes plots an estimated plane and the set of
% ground truth planes. The estimated plane corresponds with the version
% scaned with HL2 device, projected to the mocap coordinate frame. 

% load Th2m
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);

% load pc_e scanned with HL2
    pc_t=pcread(estimatedPlane.pathPoints);
    % convert lengths to mm
    xyz=pc_t.Location*1000;
    pc_e_h=pointCloud(xyz);

% project pc_e to qm coordinate reference
pc_e=myProjection_v3(pc_e_h,Th2m);

% iterative generation and plot of synthetic point clouds (pc_gt) for groundtruth planes
if boxID==0
    idxBoxes=getIDxBoxes(dataSetPath,sessionID);
else
    idxBoxes=getIDxBoxes(dataSetPath,sessionID, boxID);
end


numberOfSides=3;
groundFlag=0;
[pcmodel, planeDescriptor_gt, Nboxes] = generateSyntheticModelForScene(dataSetPath, ...
    sessionID,spatialSampling,numberOfSides,groundFlag, idxBoxes,0);
pps=getPPS(dataSetPath,sessionID);
figure,
    pcshow(pc_e,"MarkerSize",20)
	hold on
    dibujarsistemaref(estimatedPlane.tform,'e',150,2,10,'w');
    T0=eye(4);
% 	dibujarsistemaref(T0,'m',150,2,10,'w');
	pcshow(pcmodel)
if boxID==0
    for i=1:Nboxes
		boxIDt=planeDescriptor_gt.fr0.values(i).idBox;
		Tmt=planeDescriptor_gt.fr0.values(i).tform;
		dibujarsistemaref(Tmt,boxIDt,150,2,10,'w');
    end
else
    i=find(pps==boxID);
    boxIDt=planeDescriptor_gt.fr0.values(i).idBox;
	Tmt=planeDescriptor_gt.fr0.values(i).tform;
	dibujarsistemaref(Tmt,boxIDt,150,2,10,'w');
end

	xlabel 'x'
	ylabel 'y'
	zlabel 'z'
	grid on
	title (['scanned pc vs gt pc. Estimation ID ' num2str(estimatedPlane.idPlane) ' eADD=' num2str(eADD_m')])



end