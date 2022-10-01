function [pout] = myProjection_v2(p,R,t)
%MYPROJECTION Projects points p using the transformatio matrix T

    R4=eye(4);
    R4(1:3,1:3)=R;
    tform = affine3d(R4);
    N=p.Count;
    D=repmat(t',N,1);
    p = pctransform(p,tform);%rotation
    pout= pctransform(p,D);%displacement
    
end

