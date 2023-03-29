function [er, et, eL1, eL2,  eADD, ninliers, dcamera, Testimated_m, L1gt, L2gt] = comparePlanes_v2(scene, boxID,...
    gtPlanePose, detectedPlane, spatialSampling, datasetPath,frame, cameraPose, tao)
%COMPAREPLANES compute error metrics between estimated and ground truth
%values
% er: as rotation error in degrees
% et: as traslation error in mm
% eL1: as length L1 error in percentage; relative to L1 ground truth
% eL2: as length L2 error in percentage; relative to L2 ground truth
% eADD: as average distance distinguishable / number of points of gt model
% Furthermore, computes two indicators
% ninliers: number of inliers in the plane detected
% dcamera: distance between camera and plane estimated, in mm

% _v2 se asume que las poses estimadas llegan en el sistema de coordeandas
% qm, en consecuencia, se eliminan las etapas que proyectaban a ese
% sistema. También se asume que las poses estimadas llegan en mm
%   Detailed explanation goes here

%% compute rotation and translation errors: er, et
Tref=gtPlanePose;
Testimated_m=detectedPlane.tform;%mt
[et, er]=computeSinglePoseError(Tref,Testimated_m);%as stated in Hodane 2016 we compute Reference-Estimated
%% compute lenght errors; eL1, eL2
% load gt lengths
lengths_array=getPreviousKnowledge(datasetPath,boxID); % Id,Type,Heigth(cm),Width(cm),Depth(cm)
H=lengths_array(2)*10;%mm
W=lengths_array(3)*10;%mm
D=lengths_array(4)*10;%mm

if W>=D
    L1gt=D;
    L2gt=W;
else
    L1gt=W;
    L2gt=D;    
end

eL1=abs(L1gt-detectedPlane.L1*1000)/L1gt;%mm
eL2=abs(L2gt-detectedPlane.L2*1000)/L2gt;

%% compute average distance distinguishable error eADD
% pps=getPPS(datasetPath,scene,frame);
% matchIndex=find(pps==boxID);
% planeDescriptor=convertPK2PlaneObjects_v2(datasetPath,scene,0,frame);
% 
% planeObject=planeDescriptor.fr0.values(matchIndex);

plane_model=createSingleBoxPC_topSide(L1gt,L2gt,H,spatialSampling);%centered in the origin
% project the pc with the gt pose
    plane_model_gt=myProjection_v3(plane_model,Tref);
% project the pc with the estimated pose
    plane_model_estimated=myProjection_v3(plane_model,Testimated_m);
% compute the average distance distingushable
eADD=compute_eADD(plane_model_gt,plane_model_estimated, er, tao);%mm


%% compute detection metrics: number of inliers (n_inliers) and distance to camera (dc)
pc_scanned=pcread(detectedPlane.pathPoints);
ninliers=pc_scanned.Count; 

dcamera=(norm(mean(pc_scanned.Location))-norm(cameraPose(1:3,4)))*1000;%mm
% zoom in an specific case
% if boxID==17 & detectedPlane.idPlane==2
%     disp('stop the code')
% end
% 
% % % validation figure
% figure,
% pcshow(plane_model_gt,MarkerSize=20)
% hold on
% pcshow(plane_model_estimated)
% hold on
% dibujarsistemaref(eye(4),'m',150,2,10,'w')
% dibujarsistemaref(Tref,'gt',150,2,10,'w')
% dibujarsistemaref(Testimated_m,'e',150,2,10,'w')
% xlabel 'x'
% ylabel 'y'
% zlabel 'z'
% title(['b_{ID}=' num2str(boxID) ', p_{ID}=' num2str(detectedPlane.idPlane) ', e_r=' num2str(er) ', e_t=' num2str(et) ', e_{ADD}=' num2str(eADD) ', d_{c}=' num2str(dcamera) ])
% % % % title (['Plane model projected with $$\hat{P}$$ and P (greater marker). ' ],'Interpreter','Latex')
% % 
% mygc=mean(pc_scanned.Location);
% norm_plano=norm(mygc);
% norm_camera=norm(cameraPose(1:3,4));
% dc=norm_plano-norm_camera;
% figure,
% pcshow(pc_scanned)
% hold on
% plot3(mygc(1),mygc(2),mygc(3),'o')
% hold on
% dibujarsistemaref(cameraPose,'h_m',1,2,10,'w')
% dibujarsistemaref(eye(4),'h',1,2,10,'w')
% title (['d_c = ' num2str(mydc)])
% xlabel 'x'
% ylabel 'y'
% zlabel 'z'
% 
end

