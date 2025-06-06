function myPlotSinglePlane_woutPK(planeDescriptor, boxID, fc)
%MYPLOTSINGLEPLANE Plots three data associated with a plane:
% (1) raw points (or inliers to the model)
% (2) normal of plain
% (3) identifier of the plane


if nargin==2
    fc='white';
end

p=[planeDescriptor.geometricCenter]';
n=planeDescriptor.unitNormal';
normalColor='r';
% if(planeDescriptor.antiparallelFlag)
%     normalColor='w';
% end
% [x1 y1 z1 ] = computeBoundingPlanev2(planeDescriptor);
% 
% % Ncomp=size(planeDescriptor.pathPoints,2);
% if planeDescriptor.idFrame==0
%     pc = myPCreadComposedPlane_soft(planeDescriptor.pathPoints);%in [mm]; indices begin at 0
% else
%     pc = myPCread(planeDescriptor.pathPoints);%in [mm]; indices begin at 0
% end
pc=myPCread(planeDescriptor.pathPoints);%mm

% (1) plot raw points
pcshow(pc)
hold on
% (2) plot plane normal
quiver3(p(1),p(2), p(3),n(1), n(2), n(3),normalColor);

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

 
end

