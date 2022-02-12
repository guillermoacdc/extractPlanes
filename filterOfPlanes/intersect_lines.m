% from Unisalle project
% 2019
function [out,Pc]=intersect_lines(Px,u,Pa,Pb)
% Detects when two lines (l1, l2) have the same slope and returns out=1; 
% otherwise returns 0
% line1=[Px, u]
% line2=[Pa, Pb]
% Px: geometric center of the 2D pointcloud
% u: 2d vector with angle alpha; alpha goes from 0 to pi
% Pa: point a of the convex hull
% Pb: point b of the convex hull
% Pa, Pb are adjacent points
% Examples

% 
% E1. line1 = line2   --- out=1
% E2. line1 = half line2   --- out=1

m1=u(1,2)/u(1,1);%slope of u
m2=(Pb(1,2)-Pa(1,2))/(Pb(1,1)-Pa(1,1));%slope of line2
b1=Px(1,2)-m1*Px(1,1);%vertical intersection of line Px in the case Px's slope would be m1
b2=Pa(1,2)-m2*Pa(1,1);%vertical intersection of line Pa in the case Pa's slope would be m2
if m1<1.6331e+16 && m2<1.6331e+16
    if m1==0 && m2==0
        alfa=Inf;        
    else
        Pc(1,1)=(b2-b1)/(m1-m2);%??
        Pc(1,2)=m1*Pc(1,1)+b1;
        alfa=(Pc-Pa)/(Pb-Pa);        
    end
else
    if m1<1.6331e+16 && m2>=1.6331e+16
        Pc(1,1)=Pa(1,1);
        Pc(1,2)=m1*Pc(1,1)+b1;        
        alfa=(Pc-Pa)/(Pb-Pa);
    else
        if m1>=1.6331e+16 && m2<1.6331e+16
            Pc(1,1)=Px(1,1);
            Pc(1,2)=m2*Pc(1,1)+b2;                
            alfa=(Pc-Pa)/(Pb-Pa);
        else
            alfa=Inf;
        end
    end
end

if alfa>=1 || alfa<0
    out=false;
else
    out=true;
end
