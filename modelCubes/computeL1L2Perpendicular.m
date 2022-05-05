function [L1,L2, Tout, rotatePlot] = computeL1L2Perpendicular(pc,planeDescriptor, figureFlag)
%COMPUTEL1L2PERPENDICULAR Computes the parameters L1, L2 of a point cloud
%that represents a plane
% Assumptions: the points in pc have been projected to a plane model
% described by modelParameters


x=pc.Location(:,1);
y=pc.Location(:,2);%represents height in pc
z=pc.Location(:,3);

alpha=myAlphaComputingv4(pc, planeDescriptor);
% alpha=myAlphaComputing(pc, planeDescriptor); 

% compute rotation matrix to align pc with reference plane
t=eye(4);
t(1:3,1:3)=roty(alpha);%angle in degrees
tform = affine3d(t);
% compute translation vector
D=repmat(planeDescriptor.geometricCenter,size(pc.Location,1),1);
pc_rotated1 = pctransform(pc,-D);%ptcloud centered in origin
pc_rotated2 = pctransform(pc_rotated1,tform);%ptcloud alligned to axis

% compute pose of the perpendicular plane
tp=eye(4);
tp(1:3,1:3)=roty(-alpha);%angle in degrees

% if(swapAlpha==0)
%     tp(1:3,1:3)=roty(-alpha);%angle in degrees
% else
%     tp(1:3,1:3)=roty(alpha);%angle in degrees
% end

tformp = affine3d(tp);
Tout=tformp.T;%rotation component of the transformation
Tout(1:3,4)=planeDescriptor.geometricCenter';%translation component of the transformation

%compute convexhull in 2D

if(planeDescriptor.planeTilt==1)%ignore z values
    x1=pc_rotated2.Location(:,1);
    y1=pc_rotated2.Location(:,2);%keep y in vertical axis of 2d
else%ignore x values
    x1=pc_rotated2.Location(:,3);
    y1=pc_rotated2.Location(:,2);%keep y in vertical axis of 2d    
end

X=max(x1)-min(x1);
Y=max(y1)-min(y1);

if (X<Y)
    rotatePlot=0;%L1 is along y axis
    L1=X;
    L2=Y;
else
    rotatePlot=1;%L2 is along y axis
	L1=Y;
    L2=X;
end

if(figureFlag)

if planeDescriptor.planeTilt==1
    horizontalLabel='x';
else
    horizontalLabel='z';
end

offsetx=min(x1)-(-X/2);
offsety=min(y1)-(-Y/2);
figure,
% subplot(121),...
    plot(x1,y1,'k*')
    hold on
%     plot(x1(k1),y1(k1),'r-','LineWidth',2)
%     plot(x1(k1),y1(k1),'bo','MarkerSize',6,'MarkerFaceColor','b')
%     plot the aproxximate rectangle
    plot([-X/2+offsetx X/2+offsetx],[Y/2 Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    plot([-X/2+offsetx X/2+offsetx],[-Y/2 -Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    plot([-X/2+offsetx -X/2+offsetx],[Y/2 -Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    plot([X/2+offsetx X/2+offsetx],[Y/2 -Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    
    title (['Plane segment ' num2str(planeDescriptor.idPlane) ' with L1=' num2str(L1) ' L2=' num2str(L2) ' \alpha=' num2str(alpha)  ' tilt=' num2str(planeDescriptor.planeTilt)])
    xlabel (horizontalLabel)
    ylabel 'y'

    
end

end

