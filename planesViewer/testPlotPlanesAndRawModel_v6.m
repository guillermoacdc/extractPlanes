clc
close all
clear all

% script to plot extracted planes from efficient RANSAC. Video version for
% meeting with advisors
%Version: all planes at a single frame

in_SceneFolderPath=['G:\Mi unidad\boxesDatabaseSample\corrida5\Depth Long Throw\'];
cd1=cd;
cd(in_SceneFolderPath);
Files1=dir('*.ply');
cd(cd1)
faceAlphaVector=0:0.1:1;
k=1;%index for video
figure,
for frame=2:9
    %% 1. load raw model 
    in_planesFolderPath=['C:/lib/outputPlanes_t9/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC
    pc_raw=pcread([Files1(frame).folder '\' Files1(frame).name]);
    [Files1(frame).folder '\' Files1(frame).name]
    theta=-pi/2;
        A = [1 0 0 0; ...
            0 cos(theta) -sin(theta) 0;...
            0 sin(theta) cos(theta) 0;...
            0 0 0 1];
        tform = affine3d(A);
    xmin=-1;
    xmax=2;
    ymin=-1.6;
    ymax=0;
    zmin=-5;
    zmax=-1;
    pc_rawt = pctransform(pc_raw,tform);%alligned ptcloud
% %     figure,
%         pcshow(pc_raw)
%         xlabel 'x'
%         ylabel 'y'
%         zlabel 'z'
%       axis ([xmin xmax ymin ymax zmin zmax])
%         title (['raw point cloud at frame ' num2str(frame)])
    %     view(2)

    %% 2. load plane model and plane parameters 
    cd1=cd;
    cd(in_planesFolderPath);
    Files=dir('*.ply');
    cd(cd1)
    NbFrames=length(Files);
    NbPlanes=NbFrames;%two additional files for rawpc
    planesCounter=0;
   
	pcshow(pc_raw)
    hold on
    for i=1:1:NbPlanes
    	[modelParameters pc_j ]=loadPlaneModel_v2(in_planesFolderPath, frame, i);
        xp=double(pc_j.Location(:,1));
        yp=double(pc_j.Location(:,2));
        zp=double(pc_j.Location(:,3));
        [x y z planeType] = computeBoundingPlane(xp, yp, zp, modelParameters(1), ...
        modelParameters(2), modelParameters(3), modelParameters(4), 10);
        if (planeType==0)
            planesCounter=planesCounter+1;
    %             pcshow(pc_j,'MarkerSize', 40)
                if (x~=0)
                    surf(x,y,z,'FaceAlpha',faceAlphaVector(end-frame), 'EdgeColor', [1 1 0]) %Plot the surface
                end
                xlabel 'x (m)'
                ylabel 'y (m)'
                zlabel 'z (m)'
                view(2)

%                 view(0,90) % for (x,y) view
    %             view(108,35)
%                 title (['Plane Number: ' num2str(i) ' with ' num2str(pc_j.Count) ' Points from ' num2str(pc_raw.Count) ])
            end
            
    end
axis ([xmin xmax ymin ymax zmin zmax])    
view (180,0)    
title (['Scene 5. Frame number ' num2str(frame)])
pause()
F(k) = getframe(gcf) ;
k=k+1;
drawnow
% hold off
end
return

% create the video writer with 1 fps
  writerObj = VideoWriter('topPlanes_f1_9_v3.avi');
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
