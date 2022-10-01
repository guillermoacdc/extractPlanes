function [pout] = myProjection(p,T)
%MYPROJECTION Projects points using the transformatio matrix T

    t=eye(4);
    t(1:3,1:3)=T(1:3,1:3);
    tform = affine3d(t);
    pc_out= pctransform(pc,tform);%rotation
    pout = pctransform(pc_out,T(1:3,4));%displacement
end

