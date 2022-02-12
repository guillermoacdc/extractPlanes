function [L1,L2, tform] = computeL1L2Perpendicular(pc,typeOfPlane,modelParameters, figureFlag)
%COMPUTEL1L2PERPENDICULAR Computes the parameters L1, L2 of a point cloud
%that represents a plane
% Assumptions: the points in pc have been projected to a plane model
% described by modelParameters


x=pc.Location(:,1);
y=pc.Location(:,2);%represents height in pc
z=pc.Location(:,3);

if(typeOfPlane==1)%compute angle with normal [1 0 0]
    alpha=computeAngleBtwnVectors([1 0 0], modelParameters(1:3));
else%compute deviation with normal [0 0 1]
    alpha=computeAngleBtwnVectors([0 0 1], modelParameters(1:3));
end
% compute rotatio matrix
t=eye(4);
t(1:3,1:3)=roty(-alpha);%angle in degrees
tform = affine3d(t);
% compute translation vector

D=repmat(modelParameters(5:7),size(pc.Location,1),1);
pc_rotated1 = pctransform(pc,-D);%ptcloud centered in origin
pc_rotated2 = pctransform(pc_rotated1,tform);%ptcloud alligned to axis

%compute convexhull in 2D
if(typeOfPlane==1)%ignore x values
    x1=pc_rotated2.Location(:,2);
    y1=pc_rotated2.Location(:,3);    
else%ignore z values
    x1=pc_rotated2.Location(:,1);
    y1=pc_rotated2.Location(:,2);    
end

X=max(x1)-min(x1);
Y=max(y1)-min(y1);

if (X<Y)
    L1=X;
    L2=Y;
else
	L1=Y;
    L2=X;
end

if(figureFlag)
% k1 = convhull(double(x1),double(y1));    

offsetx=min(x1)-(-X/2);
offsety=min(y1)-(-Y/2);
figure,
    plot(x1,y1,'k*')
    hold on
%     plot(x1(k1),y1(k1),'r-','LineWidth',2)
%     plot(x1(k1),y1(k1),'bo','MarkerSize',6,'MarkerFaceColor','b')
%     plot the aproxximate rectangle
    plot([-X/2+offsetx X/2+offsetx],[Y/2 Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    plot([-X/2+offsetx X/2+offsetx],[-Y/2 -Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    plot([-X/2+offsetx -X/2+offsetx],[Y/2 -Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    plot([X/2+offsetx X/2+offsetx],[Y/2 -Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    
    title (['Aproxximated Plane segment with L1=' num2str(L1) ' L2=' num2str(L2)])
end

end

