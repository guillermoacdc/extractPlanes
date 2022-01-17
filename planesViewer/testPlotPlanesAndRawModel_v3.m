clc
close all
clear all

% script to plot extracted planes from efficient RANSAC. Video version for
% meeting with advisors

% 1. load raw model, plane model and plane parameters 
in_path1=['G:/Mi unidad/semestre 6/1-3 AlgoritmosSeguimientoPose/PCL/sp132697151403874938.ply'];%raw model - corrida 5
in_path2=['../outputPlanes2/'];%extracted planes with efficientRANSAC
% 2. plot raw model, build planes from plane parameters, show planes  

pc_raw=pcread(in_path1);

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

        pcshow(pc_j,'MarkerSize', 40)
        surf(x,y,z,'FaceAlpha',0.5) %Plot the surface
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
%         view(0,0)
%         for (j=80:5:110)
%             view(-180,j)
%             disp(['elevation ' num2str(j)])
%             pause(3)
%         end
        
        view(2)
        title (['Plane Number: ' num2str(i) ' with ' num2str(pc_j.Count) ' Points from ' num2str(pc_raw.Count)])
        pause()
	 F(i) = getframe(gcf) ;
     drawnow
    hold off
end    

% create the video writer with 1 fps
  writerObj = VideoWriter('myVideo2.avi');
  writerObj.FrameRate = 3;
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
