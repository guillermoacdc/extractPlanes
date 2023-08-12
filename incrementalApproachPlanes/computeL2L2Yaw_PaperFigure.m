figureFlag=0;
% esta técnica no va a funcionar en los casos
% 1. planos ocluidos: el borde visible del plano superior va a definir el
% valor de L1 o L2

%omit height information
x=pc.Location(:,1)-mean(pc.Location(:,1));
y=pc.Location(:,3)-mean(pc.Location(:,3));
% Px=[planeDescriptor.geometricCenter(1) planeDescriptor.geometricCenter(3)];
Px=[0 0];

% compute indexes that belong to the perimeter of the shape
k = convhull(double(x),double(y));
n=359;
dists=[];
pcuts=[];
% search for the intersection between a virtual line (Px,u) and segments of the
% shape's perimeter. -- consider update with method presented at doi:10.3390/s19143136
    for alpha=0:1:179%ang defines the orientation of the virtual line
%        for alpha=0:10*pi/n:pi%ang defines the orientation of the virtual line
        u=[cos(alpha*pi/180),sin(alpha*pi/180)];%components of point u in horiz and vert axes
        cuts=[];%clear cuts
        for j=1:size(k,1)-1 %recorrer el contorno 
            p1=Px;
            p2=u;
            p3=[x(k(j)),y(k(j))];%point in the convex hull
            p4=[x(k(j+1)),y(k(j+1))];%adjacent point
            [out,Pc]=intersect_lines(p1,p2, p3, p4 );
            if out
               cuts=[cuts;Pc];%coordenadas de puntos de intersección entre línea [0 u] y la línea [p3 p4], para un vector u fijo; 
            end
        end
        pcuts=[pcuts;cuts];%coordenadas de puntos de intersección entre línea [0 u] y la línea [p3 p4], para un vector u con múltiples orientaciones 
        dists=[dists,norm(cuts(1,:)-cuts(2,:))];%distancia entre los puntos de intersección
    end
 
% computing L1
    [dist_min,ind_min]=min(dists);
%     [dist_max,ind_max]=max(dists);%innecesario
    L1=dist_min;
% computing alpha*    
    cuts=[];
%     ang=(ind_min*pi/n)+pi/2;%alpha*; orientation of L2. Note that you can add or substract pi/2
    ang=(ind_min*1)-90;%alpha*; orientation of L2. Note that you can add or substract pi/2
% computing L2    
    u=[cos(ang*pi/180),sin(ang*pi/180)];    
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
% t(1:3,1:3)=roty((pi/2-ang)*180/pi);%angle in degrees
tform = affine3d(t);
Tout=tform.T;
Tout(1:3,4)=planeDescriptor.geometricCenter';

    L1_p1=[pcuts(2*ind_min-1,1),pcuts(2*ind_min-1,2)];%L1_p1
    L1_p2=[pcuts(2*ind_min,1),pcuts(2*ind_min,2)];%L1_p2
    L2_p1=[cuts(1,1),cuts(1,2)];
    L2_p2=[cuts(2,1),cuts(2,2)];
    D1=norm(L1_p1-L2_p2);
    D2=norm(L2_p1-L1_p2);
    myOccludedIndex=max(D1,D2)/min(D1,D2);%experimental index


    
figure,
	h1 = axes;
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
    color_L1=[0.2,0.2,0.2];
    color_L2=[0.5,0.2,0.5];
    plot(Px(1,1),Px(1,2),'mo','MarkerSize',6,'MarkerFaceColor','m');%plot geometric center
%     dibujarlinea([Px-[2,0]*0.1,0]', [Px+[2,0]*0.1,0]', color_giro,2)%linea L a 0 grados
    
%     plot intersectin points at L1
    plot(L1_p1(1), L1_p1(2),'bo','MarkerSize',8,'MarkerFaceColor','g')%
    plot(L1_p2(1), L1_p2(2),'bo','MarkerSize',8,'MarkerFaceColor','g')%
%     plot intersection points at L2
    plot(L2_p1(1), L2_p1(2),'bo','MarkerSize',8,'MarkerFaceColor','g')%
    plot(L2_p2(1), L2_p2(2),'bo','MarkerSize',8,'MarkerFaceColor','g')%

%   plot line L1
%     dibujarlinea([Px+(L1_p1-Px)*1.5,0]', [Px+(L1_p2-Px)*1.5,0]', color_giro,1)%%linea L a alpha* grados
    dibujarlinea([L1_p1,0]', [L1_p2,0]', color_L1,1)%
%   plot line L2    
    dibujarlinea([L2_p1,0]', [L2_p2,0]', color_L2,1)%

%     myIndex=abs(D1-D2)/0.5;%experimental index
    grid
    axis('square')
    set(h1, 'Xdir', 'reverse')




