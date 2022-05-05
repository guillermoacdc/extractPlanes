function [alphaSign ix] = computeAlphaSign(pc, planeDescriptor)
%COMPUTEALPHASIGN computes the sign of angle alpha between plane's normal 
% and reference vector
%   Assumptions: 
% * pc is centered in the origin of q_ref


% cut length in axis y to enable L1 oriented along y-axis
pc_temp=cutLength_Y(pc,planeDescriptor.geometricCenter,0.3);% keep 30% of height in y axis

% compute components xL, zL
[xL zL yL ix iz iy] = computeFartherPointv2([0 0 0]',pc_temp, [1 0 0]', [0 0 1]', [0 1 0]');

% apply sign algorithm
if (planeDescriptor.planeTilt==1)
    if (xL>0)
        if(zL>0)
            alphaSign=-1;
        else
            alphaSign=1;
        end
    else
        if(zL>0)
            alphaSign=1;
        else
            alphaSign=-1;
        end
    end
else
    if (xL>0)
        if(zL>0)
            alphaSign=1;
        else
            alphaSign=-1;
        end
    else
        if(zL>0)
            alphaSign=-1;
        else
            alphaSign=1;
        end
    end

end


end

