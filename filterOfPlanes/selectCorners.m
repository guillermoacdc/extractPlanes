function ind_corners=selectCorners(x,y)
% compute the intern points of a point cloud pc. Generally this pc is
% computed as the convex hull of a raw pc
% based on the difference of angles (wrt to horizontal line) between 
% adjacent points of pc
% uses a treshold of 20 to classify a point as intern point
% 
npoints=size(x,1)-1;
deltam=zeros(npoints,1);
x=[x;x(1,1)];%adds one element (a) at the end of the vector, a: second element
y=[y;y(1,1)];
% x=[x;x(2,1)];%adds one element (a) at the end of the vector, a: second element
% y=[y;y(2,1)];
for i=2:npoints+1
    mb=atan2((y(i,1)-y(i-1,1)),(x(i,1)-x(i-1,1)));
    ma=atan2((y(i+1,1)-y(i,1)),(x(i+1,1)-x(i,1)));
    delta_m=abs(ma-mb);
%     if delta_m>pi
%         delta_m=2*pi-delta_m;
%     end
    deltam(i-1)=delta_m;
end
ind_corners=find(deltam(:,1)>20*pi/180);