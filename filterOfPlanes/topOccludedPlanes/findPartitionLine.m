function [L1_p1 L1_p2 L2_p1 L2_p2] = findPartitionLine(pc, figureFlag)
%FINDPARTITIONLINE Summary of this function goes here
%   Detailed explanation goes here
% [n,2]<-size(pc)

x=pc(:,1);
y=pc(:,2);
Px=[mean(x) mean(y)];

% compute indexes that belong to the perimeter of the shape
k = convhull(double(x),double(y));
n=360;
dists=[];
pcuts=[];
% search for the intersection between a virtual line (Px,u) and segments of the
% shape's perimeter
    for alpha=0:pi/n:pi%ang defines the orientation of the virtual line
%        for alpha=0:10*pi/n:pi%ang defines the orientation of the virtual line
        if alpha==pi/2
           disp('error in computeL1L2Parallel. alpha=pi/2') %preguntar tipo de error
        end
        u=[cos(alpha),sin(alpha)];%components of point u in horiz and vert axes
        cuts=[];%clear cuts
        for j=1:size(k,1)-1 %recorrer el contorno 
            p1=Px;
            p2=u;
            p3=[x(k(j)),y(k(j))];%point in the convex hull
            p4=[x(k(j+1)),y(k(j+1))];%adjacent point
            [out,Pc]=intersect_lines(p1,p2, p3, p4 );
            if out
               cuts=[cuts;Pc];
            end
        end
        pcuts=[pcuts;cuts];
        dists=[dists,norm(cuts(1,:)-cuts(2,:))];
    end
 
% computing L1
    [dist_min,ind_min]=min(dists);
    [dist_max,ind_max]=max(dists);
    L1=dist_min;
% computing alpha*    
    cuts=[];
    ang=(ind_min*pi/n)+pi/2;%alpha*; orientation of L2
% computing L2    
    u=[cos(ang),sin(ang)];    
    for j=1:size(k,1)-1
        [out,Pc]=intersect_lines(Px,u,[x(k(j,1),1),y(k(j,1),1)],[x(k(j+1,1),1),y(k(j+1,1),1)]);
        if out%detects intersection between line (Px,u), and line (p3,p4)
           cuts=[cuts;Pc];%Pc contains the intersection coordinate
        end
    end    
    Plb=cuts(1,:);
    Plf=cuts(2,:);
    L2=norm(Plb-Plf);%length
   
t=eye(4);
t(1:3,1:3)=roty(-ang*180/pi);%angle in degrees
tform = affine3d(t);
Tout=tform.T;

% Tout(1:3,4)=planeDescriptor.geometricCenter';

    L1_p1=[pcuts(2*ind_min-1,1),pcuts(2*ind_min-1,2)];%L1_p1
    L1_p2=[pcuts(2*ind_min,1),pcuts(2*ind_min,2)];%L1_p2
    L2_p1=[cuts(1,1),cuts(1,2)];
    L2_p2=[cuts(2,1),cuts(2,2)];
%     A=[L1_p1 ];
%     B=[L1_p2 ];
%     D1=norm(L1_p1-L2_p2);
%     D2=norm(L2_p1-L1_p2);
%     myOccludedIndex=max(D1,D2)/min(D1,D2);%experimental index


if(figureFlag==1)
% if(1)    
    
   
    figure,
%   plot the point cloud in gray color
    plot(x,y,'*','color', [.5 .5 .5])%gray color in vector
	xlabel 'x'
    ylabel 'z'

    hold on
%   plot a red line that highlights the perimeter of the point cloud
    plot(x(k),y(k),'r-','LineWidth',2)
%   plot the geometric center of the pointcloud
    plot(Px(1,1),Px(1,2),'ko','LineWidth',3)%geometric center
%   plot a line L centered at the geometric center of the Convex-Hull and with angle alpha=0
    color_giro=[0.2,0.2,0.2];
    plot(Px(1,1),Px(1,2),'mo','MarkerSize',6,'MarkerFaceColor','m');%plot geometric center
    
%     plot intersectin points at L1
    plot(L1_p1(1), L1_p1(2),'bo','MarkerSize',8,'MarkerFaceColor','g')%
    plot(L1_p2(1), L1_p2(2),'bo','MarkerSize',8,'MarkerFaceColor','g')%
%     plot intersection points at L2
    plot(L2_p1(1), L2_p1(2),'bo','MarkerSize',8,'MarkerFaceColor','g')%
    plot(L2_p2(1), L2_p2(2),'bo','MarkerSize',8,'MarkerFaceColor','g')%

%   plot line L1
    dibujarlinea([Px+(L1_p1-Px)*1.5,0]', [Px+(L1_p2-Px)*1.5,0]', color_giro,1)%%linea L a alpha* grados
    grid on

%     axis('square')



end

end

