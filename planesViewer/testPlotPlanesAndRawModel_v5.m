clc
close all
clear all

% script to plot extracted planes from efficient RANSAC. Video version for
% meeting with advisors
frame=20;
in_planesFolderPath=['C:/lib/outputPlanes_t9/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC
in_SceneFolderPath=['C:/lib/inputScenes/'];


%% 1. load raw model 
pc_raw=pcread([in_SceneFolderPath + "frame" + num2str(frame) + ".ply"]);
theta=-pi/2;
    A = [1 0 0 0; ...
        0 cos(theta) -sin(theta) 0;...
        0 sin(theta) cos(theta) 0;...
        0 0 0 1];
    tform = affine3d(A);
xmin=-2;
xmax=3;
ymin=0;
ymax=8;
zmin=-1.6;
zmax=0;
pc_rawt = pctransform(pc_raw,tform);%alligned ptcloud
figure,
	pcshow(pc_raw)
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
%     axis ([xmin xmax ymin ymax zmin zmax])
    title (['raw point cloud at frame ' num2str(frame)])
%     view(2)

%% 2. load plane model and plane parameters 
cd1=cd;
cd(in_planesFolderPath);
Files=dir('*.ply');
cd(cd1)
NbFrames=length(Files);
NbPlanes=NbFrames;%two additional files for rawpc

% in_path1=['G:/Mi unidad/semestre 6/1-3 AlgoritmosSeguimientoPose/PCL/sp132697151403874938.ply'];%raw model - corrida 5

% in_folderPath=[in_SceneFolderPath 'frame (' num2str(frame) ')/' ];
planesCounter=0;
k=1;%index for video
figure,
for i=1:1:NbPlanes
% for i=1:47:48
	pcshow(pc_raw)
    hold on
    [modelParameters pc_j ]=loadPlaneModel_v2(in_planesFolderPath, frame, i);
        %pc_j=pcdenoise(pc_j);%esta etapa está compensando el error de componentes conexos en efficientRANSAC
        xp=double(pc_j.Location(:,1));
        yp=double(pc_j.Location(:,2));
        zp=double(pc_j.Location(:,3));
%         
        [x y z planeType] = computeBoundingPlane(xp, yp, zp, modelParameters(1), ...
            modelParameters(2), modelParameters(3), modelParameters(4), 10);
                
        
%         if (planeType==0)
        if (1)    
            planesCounter=planesCounter+1;
            pcshow(pc_j,'MarkerSize', 40)
            if (x~=0)
                surf(x,y,z,'FaceAlpha',0.5) %Plot the surface
            end
            xlabel 'x (m)'
            ylabel 'y (m)'
            zlabel 'z (m)'
            view(2)
%             view(0,0) %for top view
%             view(0,90) % for (x,y) view
%             view(108,35)
            title (['Plane Number: ' num2str(i) ' with ' num2str(pc_j.Count) ' Points from ' num2str(pc_raw.Count) ])
            pause()
            F(k) = getframe(gcf) ;
            k=k+1;
            drawnow
            hold off
        end
end    
return
% create the video writer with 1 fps
  writerObj = VideoWriter('nonExpectedPlanes_v3.avi');
  writerObj.FrameRate = 2;
  % set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);
