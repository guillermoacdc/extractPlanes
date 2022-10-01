function myPlotSinglePlane_v3(planeDescriptor, boxID, frameFlag)
%MYPLOTSINGLEPLANE Plots three data associated with a plane:
% (1) raw points (or inliers to the model)
% (2) normal of plain
% (3) the contour of the plane with four lines.
% (4) identifier of the plane
% (5) framework of the plane; just if input frameFlag is true
if nargin==2
    frameFlag=false;
end

p=[planeDescriptor.geometricCenter]';
n=planeDescriptor.unitNormal';
normalColor='r';
if(planeDescriptor.antiparallelFlag)
    normalColor='w';
end
[x1 y1 z1 ] = computeBoundingPlanev2(planeDescriptor);
pc = pcread(planeDescriptor.pathPoints);%in [mt]; indices begin at 0

% (1) plot raw points
pcshow(pc)
hold on
% (2) plot plane normal
quiver3(p(1),p(2), p(3),n(1), n(2), n(3),normalColor);
% (3) plot contour of the plane
if (planeDescriptor.type==0)
    myPlotPlaneContour(planeDescriptor)
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
        [num2str(boxID) '-' num2str(planeDescriptor.idPlane)],'Color','white');
else
    H=text(planeDescriptor.geometricCenter(1),...
        planeDescriptor.geometricCenter(2),...
        planeDescriptor.geometricCenter(3),...
        num2str(planeDescriptor.idPlane),'Color','white');
end

set(H,'FontSize',15)

% (5) plot the frame of the plane
if frameFlag
    scale=1;
    width=1;
    T=planeDescriptor.tform;
    dibujarsistemaref (T,' ',scale,width,10,'white');
end
 
end

