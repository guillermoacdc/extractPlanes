function [alpha, ix, pc_temp] = computeAlpha(pc, planeDescriptor)
%COMPUTEALPHA computes the sign and magnitude of angle alpha. This is the
%angle required to allign the plane with a reference framework (xy or zy)

%   Assumptions: 
% * pc is centered in the origin of q_ref

% cut length in axis y to enable L1 oriented along y-axis
pc_temp=cutLength_Y(pc,planeDescriptor.geometricCenter,0.3);% keep 30% of height in y axis

% compute components xL, zL
% [xL zL yL ix iz iy] = computeFartherPointv2([0 0 0]',pc_temp, [1 0 0]', [0 0 1]', [0 1 0]');
[xmax, ymax, zmax, ix, iz, iy] = computeFartherPointv3(pc_temp);
xL=pc_temp.Location(ix,1);
zL=pc_temp.Location(ix,3);
% xL=pc_temp.Location(ix,1);
% compute beta
if (planeDescriptor.planeTilt==1)%xyTilt
    beta=computeAngleBtwnVectors([0 0 1], planeDescriptor.unitNormal);
else%zyTilt-- error in plane 101-5
    beta=computeAngleBtwnVectors([1 0 0], planeDescriptor.unitNormal);   
%         beta=computeAngleBtwnVectors([1 0 0], -planeDescriptor.unitNormal);   
end

% apply alpha's algorithm
alpha=beta;
if (planeDescriptor.planeTilt==0)
    if (xL>0)
        if(zL>0)
%             if beta>180
            if beta>45% in this case the computeAngleBtwnVectors function returns beta' (see slide 24)
%                 alpha=beta-180;
                alpha=180-beta;
            end
            alpha=-alpha;
        else
            if beta>90
                alpha=180-beta;
            end
%             alphaSign=1;
        end
    else
        if(zL>0)
            if beta>90
                alpha=180-beta;
            end
%             alphaSign=1;
        else
%             if beta>180
            if beta>45
%                 alpha=beta-180;
                alpha=180-beta;
            end
            alpha=-alpha;
        end
    end
else
    if (xL>0)
        if(zL>0)
            if beta>45
                alpha=90-beta;
            end
%             alphaSign=1;
        else
            if beta>90
                alpha=beta-90;
            end
            alpha=-alpha;
        end
    else
        if(zL>0)
            if beta>90
                alpha=beta-90;
            end
            alpha=-alpha;
        else
            if beta>45
                alpha=90-beta;
            end
%             alphaSign=1;
        end
    end

end

