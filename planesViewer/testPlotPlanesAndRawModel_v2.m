clc
close all
clear all

% script to plot extracted planes from efficient RANSAC

% 1. load raw model, plane model and plane parameters 
in_path1=['G:/Mi unidad/semestre 6/1-3 AlgoritmosSeguimientoPose/PCL/sp132697151403874938.ply'];%raw model - corrida 5
in_path2=['../outputPlanes2/'];%extracted planes with efficientRANSAC
% 2. plot raw model, build planes from plane parameters, show planes  

pc_raw=pcread(in_path1);
% theta=-pi/2;
%     A = [1 0 0 0; ...
%         0 cos(theta) -sin(theta) 0;...
%         0 sin(theta) cos(theta) 0;...
%         0 0 0 1];
%     tform = affine3d(A);
% pc_raw = pctransform(pc_raw,tform);%alligned ptcloud
%plot
figure,
for i=1:1:12
	pcshow(pc_raw)
    hold on
    [modelParameters pc_j ]=loadPlaneModel_v2(in_path2, i);
        xp=double(pc_j.Location(:,1));
        yp=double(pc_j.Location(:,2));
        zp=double(pc_j.Location(:,3));
        
        [x y z flag] = createPlaneFromModel_v2(xp, yp, zp, modelParameters(1), ...
            modelParameters(2), modelParameters(3), modelParameters(4));
% 	if (flag)
        pcshow(pc_j,'MarkerSize', 40)

        surf(x,y,z,'FaceAlpha',0.5) %Plot the surface
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
%         view(0,0)
        view(2)
        title (['Plane Number: ' num2str(i) ' with ' num2str(pc_j.Count) ' Points from' num2str(pc_raw.Count)])

%         title (['Plane Number: ' num2str(i) ' with ' num2str(pc_j.Count) ...
%             ' Points from' num2str(pc_raw.Count) ". [A, B, C, D]=[" ...
%             num2str(modelParameters(1)) ', ' num2str(modelParameters(2)) ', '...
%             num2str(modelParameters(3)) ', ' num2str(modelParameters(4)) ']'])
        pause()
%     end
    hold off
end    
% 	view(0,180)
% 	hold on