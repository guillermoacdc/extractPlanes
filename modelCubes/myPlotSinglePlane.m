function myPlotSinglePlane(planeDescriptor)
%MYPLOTSINGLEPLANE Summary of this function goes here
%   Detailed explanation goes here
p=[planeDescriptor.geometricCenter]';
n=planeDescriptor.unitNormal';
normalColor='r';
if(planeDescriptor.antiparallelFlag)
    normalColor='w';
end
[x1 y1 z1 ] = computeBoundingPlanev2(planeDescriptor);
pc = pcread(planeDescriptor.pathPoints);%in [mt]; indices begin at 0
% plot points
pcshow(pc)
hold on
%plot plane normal
quiver3(p(1),p(2), p(3),n(1), n(2), n(3),normalColor);

if (planeDescriptor.type==0)
    myPlotPlaneContour(planeDescriptor)
else
    surf(x1,y1,z1,'FaceAlpha',0.5)
end
H=text(planeDescriptor.geometricCenter(1),...
        planeDescriptor.geometricCenter(2),...
        planeDescriptor.geometricCenter(3),...
        num2str(planeDescriptor.idPlane),'Color','red');
set(H,'FontSize',15)
 
end

