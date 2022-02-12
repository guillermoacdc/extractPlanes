function [L1 L2 tform]=computeL1L2Parallel(pc, typeOfPlane, modelParameters, figureFlag)
%COMPUTEL1L2PARALLEL Computes the parameters L1, L2 of a point cloud
%that represents a plane
% Assumptions: the points in pc have been projected to a plane model
% described by modelParameters


% esta técnica no va a funcionar en los casos
% 1. planos ocluidos: el borde visible del plano superior va a definir el
% valor de L1 o L2

%omit height information
x=pc.Location(:,1);
y=pc.Location(:,3);
Px=[modelParameters(5) modelParameters(7)];%geometric center

k = convhull(double(x),double(y));
n=360;
dists=[];
pcuts=[];
    for ang=0:pi/n:pi
        if ang==pi/2
           disp('error') %preguntar tipo de error
        end
        u=[cos(ang),sin(ang)];
        cuts=[];
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
        if out
           cuts=[cuts;Pc];
        end
    end    
    Plb=cuts(1,:);
    Plf=cuts(2,:);
    L2=norm(Plb-Plf);%length
   
t=eye(4);
t(1:3,1:3)=roty(-ang*180/pi);%angle in degrees
tform = affine3d(t);
    
if(figureFlag==1)
    figure,
    plot(x,y,'k*')
    hold on
    plot(x(k),y(k),'r-')
    plot(Px(1,1),Px(1,2),'mo')
    plot(pcuts(2*ind_min-1,1),pcuts(2*ind_min-1,2),'bo','MarkerSize',8,'MarkerFaceColor','g')
    plot(pcuts(2*ind_min,1),pcuts(2*ind_min,2),'bo','MarkerSize',8,'MarkerFaceColor','g')
    plot(cuts(1,1),cuts(1,2),'bo','MarkerSize',8,'MarkerFaceColor','y')
    plot(cuts(2,1),cuts(2,2),'bo','MarkerSize',8,'MarkerFaceColor','y')
    title 'parallel point cloud in 2D'

end

end