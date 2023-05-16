function [L1,L2, ref_T_p, L2toY] = computeL1L2Perpendicular_v2(pc,planeDescriptor, figureFlag)
%COMPUTEL1L2PERPENDICULAR Computes the parameters L1, L2 of a point cloud
%that represents a plane
% Assumptions: 
% * all input planes are perpendicular to ground plane
% * the points in pc have been projected to a plane model 
% * planes are non-occluded
% * there exists a tilt value for each plane

% outputs
% L1: length L1 of the plane
% L2: length L2 of the plane; L1<L2
% ref_T_p: transformation matrix from reference framework to plane
% framework
% L2toY: boolean variable that describes if a perpendicular plane keeps its
% L2 value along Y axis

%% compute plane pose (ref_T_p) and p_T_ref

% center the point cloud in the origin of q_ref
D=repmat(planeDescriptor.geometricCenter,pc.Count,1);
pc = pctransform(pc,-D);%ptcloud centered in origin

% compute alfa
[alpha, ia, ~] = computeAlpha(pc, planeDescriptor);
% if (planeDescriptor.planeTilt==1)%xyTilt
%     alpha=computeAngleBtwnVectors([0 0 1], planeDescriptor.unitNormal);
% else%zyTilt
%     alpha=computeAngleBtwnVectors([1 0 0], planeDescriptor.unitNormal);   
% end
% [alphaSign ia]=computeAlphaSign(pc, planeDescriptor);
% alpha=alphaSign*alpha;

[p_T_ref, ref_T_p ]=computeTransformations(alpha, planeDescriptor);

%% apply transformation to allign pc with reference frame and measure lengths
% apply transformation
% pc_alligned=applyTransformation(pc, p_T_ref);
pc_alligned=applyTransformation(pc, ref_T_p);
% convert to 2D data
% if(planeDescriptor.planeTilt==1)%ignore z values
    x1=pc_alligned.Location(:,1);
    y1=pc_alligned.Location(:,2);%keep y in vertical axis of 2d
% else%ignore x values
%     x1=pc_alligned.Location(:,3);
%     y1=pc_alligned.Location(:,2);%keep y in vertical axis of 2d    
% end

X=max(x1)-min(x1);
Y=max(y1)-min(y1);

if (Y>=X)
    L2toY=true;%L2 is along y axis
    L1=X;
    L2=Y;
else
    L2toY=false;%L2 is along x/z axis
	L1=Y;
    L2=X;
end


if(figureFlag)
% first plot
    if planeDescriptor.planeTilt==1
        horizontalLabel='x';
    else
        horizontalLabel='z';
    end

    offsetx=min(x1)-(-X/2);
    offsety=min(y1)-(-Y/2);
    figure,

    plot(x1,y1,'k*')
    hold on
%     plot the aproxximate rectangle
    plot([-X/2+offsetx X/2+offsetx],[Y/2 Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    plot([-X/2+offsetx X/2+offsetx],[-Y/2 -Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    plot([-X/2+offsetx -X/2+offsetx],[Y/2 -Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    plot([X/2+offsetx X/2+offsetx],[Y/2 -Y/2]+[offsety offsety],'Color','k','LineStyle','--')
    
    title (['Plane id ' num2str(planeDescriptor.idPlane) ' with L1=' num2str(L1) ' L2=' num2str(L2) ' \alpha=' num2str(alpha)  ' tilt=' num2str(planeDescriptor.planeTilt) ' L2toY: ' num2str(L2toY)])
    xlabel (horizontalLabel)
    ylabel 'y'

    
    % second plot
    T2=eye(4);
    T2(1:3,1:3)=ref_T_p(1:3,1:3);
%     T2(1:3,1:3)=p_T_ref(1:3,1:3);

    figure,
	    pcshow(pc)
        hold on
        pcshow(pc_alligned)
        dibujarsistemaref (eye(4),0,150,1)%ref
        dibujarsistemaref (T2,1,100,1)%rotated
        plot3(pc.Location(ia,1),pc.Location(ia,2),pc.Location(ia,3),'yo')
        view(2)
        camup([0 1 0])
	    xlabel 'x'
	    ylabel 'y'
	    zlabel 'z'
        title (['plane ID:' num2str(planeDescriptor.idPlane)  ' tilt: ' num2str(planeDescriptor.planeTilt)  ' \alpha : ' num2str(alpha)   ])
    
end

end

