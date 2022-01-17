function  myPlotPlanesv3(pc_raw, pc_i, A, B, C, D, i)
%MYPLOTPLANESV2 Summary of this function goes here
%   Detailed explanation goes here

        xp=double(pc_i.Location(:,1));
        yp=double(pc_i.Location(:,2));
        zp=double(pc_i.Location(:,3));

        [x y z] = createPlaneFromModel(xp, yp, zp, A, B, C, D);
        myArea=(x(1,2)-x(1,1))*(y(2,1)-y(1,1));
        
            pcshow(pc_raw)
            hold on
            pcshow(pc_i,'MarkerSize', 40)
            hold on
            surf(x,y,z) %Plot the surface
%             quiver3(xn,yn,zn,un,vn,wn);
%             hold off
            xlabel 'x'
            ylabel 'y'
            zlabel 'z'
            axis([-1 0.5 -0.5 0.5 1 2.5])
            view(-10,-70)
            title (['Model:' num2str(i) '. Area1: ' num2str(myArea) '. Number of Inliers: ' num2str(pc_i.Count)])


end

