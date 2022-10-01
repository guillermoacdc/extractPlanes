function [pout] = myProjection(p,T)
%MYPROJECTION Projects points p using the transformatio matrix T

    t=eye(4);
    t(1:3,1:3)=inv(T(1:3,1:3));
    tform = affine3d(t);
    pc_out= pctransform(p,tform);%rotation
    N=pc_out.Count;
    D=repmat(T(1:3,4)',N,1);
    pout = pctransform(pc_out,D);%displacement
end

