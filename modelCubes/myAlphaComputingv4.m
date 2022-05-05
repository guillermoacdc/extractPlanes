function [alpha] = myAlphaComputing_v4(pc, planeDescriptor, plotFlag)
%MYALPHACOMPUTING Summary of this function goes here
%   Detailed explanation goes here
if(nargin==2)
    plotFlag=0;
end
% swapAlpha=0;
pc_temp=cutLength_Y(pc,planeDescriptor.geometricCenter,0.3);

[xL zL yL ia ib ic] = computeFartherPointv2(planeDescriptor.geometricCenter',pc_temp, [1 0 0]', [0 0 1]', [0 1 0]');
if (planeDescriptor.planeTilt==1)%xyTilt
    alpha=computeAngleBtwnVectors([0 0 1], planeDescriptor.unitNormal);
else%zyTilt
    alpha=computeAngleBtwnVectors([1 0 0], planeDescriptor.unitNormal);   
end
% eliminate dc component in pc
% D=repmat(planeDescriptor.geometricCenter-[xL yL zL],size(pc.Location,1),1);
D=repmat(planeDescriptor.geometricCenter,size(pc.Location,1),1);
pc = pctransform(pc,-D);%ptcloud centered in origin

signAlpha=1;
if(planeDescriptor.planeTilt==1)
    if(pc.Location(ia,1)>0)%xL>0
        if (pc.Location(ia,3)<0)%zL<0
            signAlpha=-1;
        end
    else
        if (pc.Location(ia,3)>0)%zL>0
            signAlpha=-1;
        end
    end
else
    if(pc.Location(ia,1)>0)%xL>0
        if (pc.Location(ia,3)<0)%zL<0
            signAlpha=-1;
        end
    else
        if (pc.Location(ia,3)>0)%zL>0
            signAlpha=-1;
        end
    end
end

alpha=signAlpha*alpha;

T=eye(4);
% T(1:3,4)=planeDescriptor.geometricCenter';

T2=T;
T2(1:3,1:3)=roty(-alpha);%invert alpha to plot the allignment of frame with plane
if(plotFlag)
    figure,
	    pcshow(pc_temp)
        hold on 
%         pcshow(pc)
        dibujarsistemaref (T,0,1,1)%ref
        dibujarsistemaref (T2,1,0.5,1)%rotated
        plot3(pc.Location(ia,1),pc.Location(ia,2),pc.Location(ia,3),'yo')
%         dibujarlinea([0 yL zL]', [pc.Location(ia,1),pc.Location(ia,2),pc.Location(ia,3)]', 'y',1);
%         dibujarlinea([xL yL 0]', [pc.Location(ia,1),pc.Location(ia,2),pc.Location(ia,3)]', 'y',1);
%         plot3(pc.Location(ib,1),pc.Location(ib,2),pc.Location(ib,3),'bo')
%         plot3(pc.Location(ic,1),pc.Location(ic,2),pc.Location(ic,3),'ro')
	    xlabel 'x'
	    ylabel 'y'
	    zlabel 'z'
        title (['plane ID:' num2str(planeDescriptor.idPlane)  ' tilt: ' num2str(planeDescriptor.planeTilt)  ' \alpha : ' num2str(alpha)   ])
end

end

