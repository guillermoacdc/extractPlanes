function plotEstimatedPlaneVsAllGtPlanes(estimatedPose,dataSetPath,...
    sessionID, frameID, boxID, pathPCScanned, NpointsDiagTopSide,...
    planeType, planeID, eADD_m)
% estimatedPose,dataSetPath,...
%     sessionID, boxID, pathPCScanned, NpointsDiagTopSide

% plotestimatedPoseVsAllGtPlanes plots an estimated plane and the set of
% ground truth planes. The estimated plane corresponds with the version
% scaned with HL2 device, projected to the mocap coordinate frame. 

%% load scanned pc
% load Th2m
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);

if ~isempty(pathPCScanned)% when the plane was composed (=0) we can not recover the point cloud
% load pc_e scanned with HL2
    pc_t=pcread(pathPCScanned);
    % convert lengths to mm
    xyz=pc_t.Location*1000;
    pc_e_h=pointCloud(xyz);

    % project pc_e to qm coordinate reference
    pc_e=myProjection_v3(pc_e_h,Th2m);
else
    pc_e=[];
end

%% load synthetic pc
% iterative generation of synthetic point clouds (pc_gt) for groundtruth planes
numberOfSides=3;
if boxID==0
%     generate all the gt boxes as a single PC
    boxesID=getPPS(dataSetPath,sessionID,frameID);
else
%     generate an specific gt box 
    boxesID=boxID;
end
Nboxes=length(boxesID);

[pcmodel, planeDescriptor_gt]= generateSyntheticPC(boxesID,sessionID, ...
    numberOfSides, frameID, NpointsDiagTopSide, planeType, dataSetPath);

% boxesID=getPPS(dataSetPath,sessionID);
figure,
    if ~isempty(pc_e)
        pcshow(pc_e,"MarkerSize",20)
    end
	hold on
    dibujarsistemaref(assemblyTmatrix(estimatedPose),'e',150,2,10,'w');
	pcshow(pcmodel)
    if boxID==0
        for i=1:Nboxes
		    boxIDt=planeDescriptor_gt.fr0.values(i).idBox;
		    Tmt=planeDescriptor_gt.fr0.values(i).tform;
		    dibujarsistemaref(Tmt,boxIDt,150,2,10,'w');
        end
    else
        i=find(boxesID==boxID);
	    Tmt=planeDescriptor_gt.fr0.values(i).tform;
	    dibujarsistemaref(Tmt,boxID,150,2,10,'w');
    end

	xlabel 'x'
	ylabel 'y'
	zlabel 'z'
	grid on
	title (['Estimation ID [' num2str(planeID)...
        '] eADD=' num2str(eADD_m)])



end