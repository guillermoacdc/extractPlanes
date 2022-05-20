function myPlotSinglePlane(planeDescriptor, id)
%MYPLOTSINGLEPLANE Summary of this function goes here
%   Detailed explanation goes here
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
[x1 y1 z1 ] = computeBoundingPlanev2(planeDescriptor);
pc = pcread(planeDescriptor.pathPoints);%in [mt]; indices begin at 0
% set color of pc
% pointscolor=uint8(zeros(pc.Count,3));
% pointscolor(:,1)=255;
% pointscolor(:,2)=255;
% pointscolor(:,3)=255;
% pc.Color=pointscolor;

% plot points
pcshow(pc)
hold on
%plot plane normal
quiver3(p(1),p(2), p(3),n(1), n(2), n(3),normalColor);

if (planeDescriptor.type==0)
    myPlotPlaneContour(planeDescriptor)
else

    if(~isempty(planeDescriptor.planeTilt))
        myPlotPlaneContourPerpend(planeDescriptor)
    else
        surf(x1,y1,z1,'FaceAlpha',0.5)
    end
end
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
 
end

