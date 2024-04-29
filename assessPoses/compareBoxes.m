function eADD= compareBoxes(estimatedBox,referenceBox,tao,Npointsdp,plotFlag)
%COMPATEBOXES compute error function eADD between estimated and ground truth
%values
% asume que 
% 1. las poses estimadas llegan en el sistema de coordeandas
% qm, en consecuencia, se eliminan las etapas que proyectaban a ese
% sistema. 
% 2. las poses estimadas llegan en mm
% 3. el vector sidesID de estimatedBox ya ha sido ajustado
gridStep=1;%used to fuse point clouds 
er=computeRotationError(referenceBox.tform(1:3,1:3),estimatedBox.tform(1:3,1:3));
ss=sqrt(referenceBox.height^2+referenceBox.width^2+referenceBox.depth^2)/Npointsdp;
% referenceBox.sidesID=estimatedBox.sidesID;

estimatedBox.height=referenceBox.height;
estimatedBox.width=referenceBox.width;
estimatedBox.depth=referenceBox.depth;
% estimatedBox.sidesID=referenceBox.sidesID;

pc_estimated=box2pointCloud_vss(estimatedBox,ss,gridStep);
pc_reference=box2pointCloud_vss(referenceBox,ss,gridStep);
% sort points before compare. Sort by distance to origin
% compute the norm of each point

% sort indexes by norm value
% sort elements in the point cloud


% plot lines btwn the first ten pairs of points
% myPlotLinesBtwnPcs(pc_reference,pc_estimated);
eADD=computeSingle_eADD(pc_reference,pc_estimated,er,tao);
% eADD=computeSingle_eADI(pc_reference,pc_estimated,tao);

%% plot results
if plotFlag
    p1=pc_reference.Location(end,:);
    p2=pc_estimated.Location(end,:);
%     p3=pc_reference.Location(end,:);
%     p4=pc_estimated.Location(end,:);
    pts=[p1;p2];
    % paint gt box with white 
    colorpc=[255 255 255];
    pc_reference=pcPaint(pc_reference,colorpc);
    figure,
        pcshow(pc_reference)
        hold on
        pcshow(pc_estimated)
        hold on
        plot3(pts(:,1), pts(:,2), pts(:,3))
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
end

end

