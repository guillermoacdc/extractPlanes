function  myPlotPlanes(myPlaneDescriptor, in_planesFolderPath, frame, index)
%MYPLOTPLANES Summary of this function goes here
%   Detailed explanation goes here
in_SceneFolderPath=['C:/lib/inputScenes/'];
pc_raw=pcread([in_SceneFolderPath + "frame" + num2str(frame) + ".ply"]);


for i=1:1:length(index)
    normalColor='r';
    pcshow(pc_raw)
    hold on
    [modelParameters pc_j ]=loadPlaneParameters(in_planesFolderPath, frame, index(i));
% 	update modelParameters
    p=[myPlaneDescriptor{index(i)}.geometricCenter]';
%     p=[myPlaneDescriptor{index(i)}.tform(1,4), myPlaneDescriptor{index(i)}.tform(2,4),...
%         myPlaneDescriptor{index(i)}.tform(3,4)]';%computed after project points in the plane model
    n=[myPlaneDescriptor{index(i)}.A, myPlaneDescriptor{index(i)}.B, myPlaneDescriptor{index(i)}.C]';
%     p=[modelParameters(5), modelParameters(6), modelParameters(7)]';
%     n=[modelParameters(1), modelParameters(2), modelParameters(3)]';
	
    xp=double(pc_j.Location(:,1));
    yp=double(pc_j.Location(:,2));
    zp=double(pc_j.Location(:,3));
%         
%         [x y z planeType] = computeBoundingPlane(xp, yp, zp, n(1), ...
%             n(2), n(3), myPlaneDescriptor{index(i)}.D, 10);

    [x y z ] = computeBoundingPlanev2(myPlaneDescriptor{index(i)});
        
        if(myPlaneDescriptor{index(i)}.antiparallelFlag)
                normalColor='w';
        end
        pcshow(pc_j,'MarkerSize', 40)
        hold on
        if (x~=0)
            if (myPlaneDescriptor{index(i)}.type==0)%parallel to ground plane
                %plot of contour based on transformation matrix
                myPlotPlaneContour(myPlaneDescriptor{index(i)})
            else
                surf(x,y,z,'FaceAlpha',0.5) %Plot the surface
            end
            H=text(myPlaneDescriptor{index(i)}.geometricCenter(1),...
                myPlaneDescriptor{index(i)}.geometricCenter(2),...
                myPlaneDescriptor{index(i)}.geometricCenter(3),...
                num2str(index(i)),'Color','red');
            set(H,'FontSize',15)
        end
        

        %plot plane normal
        quiver3(p(1),p(2), p(3),n(1), ...
        n(2), n(3),normalColor);
        %plot ground normal
%         quiver3(p(1),p(2), p(3), 0, 1, 0,'b');
        xlabel 'x (m)'
        ylabel 'y (m)'
        zlabel 'z (m)'
        view(2)
        
%         F(k) = getframe(gcf) ;
%         k=k+1;
%         drawnow
%         hold off
        
end    

end

