function myPlotSinglePlane_v3(planeDescriptor, boxID, frameFlag, fc)
%MYPLOTSINGLEPLANE Plots three data associated with a plane:
% (1) raw points (or inliers to the model)
% (2) normal of plain
% (3) the contour of the plane with four lines.
% (4) identifier of the plane
% (5) framework of the plane; just if input frameFlag is true
if nargin==2
    frameFlag=false;
end

if nargin==3
    fc='white';
%     fc='black';
end

p=[planeDescriptor.geometricCenter]';
n=planeDescriptor.unitNormal';
normalColor='r';
if(planeDescriptor.antiparallelFlag)
    normalColor='w';
end
[x1 y1 z1 ] = computeBoundingPlanev2(planeDescriptor);

% Ncomp=size(planeDescriptor.pathPoints,2);
if planeDescriptor.idFrame==0
    pc = myPCreadComposedPlane_soft(planeDescriptor.pathPoints);%in [mm]; indices begin at 0
else
    pc = myPCread(planeDescriptor.pathPoints);%in [mm]; indices begin at 0
end
% (1) plot raw points
pcshow(pc)
hold on
% (2) plot plane normal
quiver3(p(1),p(2), p(3),n(1), n(2), n(3),normalColor);
% (3) plot contour of the plane
if (planeDescriptor.type==0)
    myPlotPlaneContour(planeDescriptor,fc)
else

    if ~isempty(planeDescriptor.planeTilt)
        myPlotPlaneContourPerpend(planeDescriptor)
    else
        surf(x1,y1,z1,'FaceAlpha',0.5)
    end
end
% (4) plot id of the plane
if (boxID~=0)
     H=text(planeDescriptor.geometricCenter(1),...
        planeDescriptor.geometricCenter(2),...
        planeDescriptor.geometricCenter(3),...
        [num2str(boxID) '-' num2str(planeDescriptor.idPlane)],'Color',fc);
else
    H=text(planeDescriptor.geometricCenter(1),...
        planeDescriptor.geometricCenter(2),...
        planeDescriptor.geometricCenter(3),...
        num2str(planeDescriptor.idPlane),'Color',fc);
end

set(H,'FontSize',15)

% (5) plot the frame of the plane
if frameFlag
    scale=250;
    width=1;
    T=planeDescriptor.tform;
%     T=rotH2M(T);
    dibujarsistemaref (T,' ',scale,width,10,fc);
end
set(gcf,'color','w');
set(gca,'color','w'); 
end

