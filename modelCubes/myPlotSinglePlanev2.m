function myPlotSinglePlanev2(planeDescriptor, id)
%MYPLOTSINGLEPLANE Plots three data associated with a plane:
% (1) projected points (inliers to the model projected to model of plane)
% (2) normal of plain
% (3) the contour of the plane with four lines.
% (4) identifier of the plane
if nargin==1
    boxID=0;
else
    boxID=id;
end

p=[planeDescriptor.geometricCenter]';
n=planeDescriptor.unitNormal';
normalColor='r';
if(planeDescriptor.antiparallelFlag)
    normalColor='w';
end
% [x1 y1 z1 ] = computeBoundingPlanev2(planeDescriptor);
pc = pcread(planeDescriptor.pathPoints);%in [mt]; indices begin at 0
% project pc to model plane
pc_projected=projectInPlane(pc,[planeDescriptor.unitNormal planeDescriptor.D]);

% plot points
pcshow(pc_projected)
hold on
%plot plane normal
quiver3(p(1),p(2), p(3),n(1), n(2), n(3),normalColor);

if (boxID~=0)
     H=text(planeDescriptor.geometricCenter(1),...
        planeDescriptor.geometricCenter(2),...
        planeDescriptor.geometricCenter(3),...
        [num2str(boxID) '-' num2str(planeDescriptor.idPlane)],'Color','red');
else
    H=text(planeDescriptor.geometricCenter(1),...
        planeDescriptor.geometricCenter(2),...
        planeDescriptor.geometricCenter(3),...
        num2str(planeDescriptor.idPlane),'Color','red');
end

set(H,'FontSize',15)
 
end

