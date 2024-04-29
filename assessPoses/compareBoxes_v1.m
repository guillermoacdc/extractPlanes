function eADD= compareBoxes_v1(estimatedBox,referenceBox,tao,Npointsdp,plotFlag)
%COMPAREBOXES compute error function eADD between estimated and ground truth
%values
% asume que 
% 1. las poses estimadas llegan en el sistema de coordeandas
% qm, en consecuencia, se eliminan las etapas que proyectaban a ese
% sistema. 
% 2. las poses estimadas llegan en mm



gridStep=1;%used to fuse point clouds 
er=computeRotationError(referenceBox.tform(1:3,1:3),estimatedBox.tform(1:3,1:3));
ss=sqrt(referenceBox.height^2+referenceBox.width^2+referenceBox.depth^2)/Npointsdp;
% ajuste de la orientación para eR>90
if er>90
    estimatedBox.tform(1:3,1:3)=rotz(180)*estimatedBox.tform(1:3,1:3);
end
er=computeRotationError(referenceBox.tform(1:3,1:3),estimatedBox.tform(1:3,1:3));

% cree una caja en el origen. Utilice el tamaño y los lados definidos en
% gtBox
referenceBox_sidesID=adjustBoxSides(estimatedBox);
standardBox=detectedBox(1,referenceBox.depth, referenceBox.height,...
    referenceBox.width, eye(4),[],referenceBox_sidesID);
standardBox_pc=box2pointCloud_vss(standardBox,ss,gridStep);

% projects standardBox to Tref
Tref=referenceBox.tform;
pc_reference=myPcTransform(standardBox_pc,Tref);
% pc_reference=pctransform(standardBox_pc,Tref);

% projects standardBox to Testimated
Testimated=estimatedBox.tform;
pc_estimated=myPcTransform(standardBox_pc,Testimated);
% pc_estimated=pctransform(standardBox_pc,Testimated);

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
        title (['distance btwn points ' num2str(norm(p1-p2))])
end

end

