function [dco, theta_co, L1, L2, inliers]=extractMisc_FromVector(myVector)
%EXTRACTMISC_FROMVECTOR Summary of this function goes here
%   Detailed explanation goes here
N=length(myVector);
dco=zeros(N,1);
theta_co=zeros(N,1);
L1=zeros(N,1);
L2=zeros(N,1);
inliers=zeros(N,1);

for i=1:N

    dco(i)=myValidateEmpty(myVector(i).distanceToCamera,0);
    theta_co(i)=myValidateEmpty(myVector(i).angleBtwn_zc_unitNormal,0);
    L1(i)=myValidateEmpty(myVector(i).L1,0);
    L2(i)=myValidateEmpty(myVector(i).L2,0);
    inliers(i)=myValidateEmpty(myVector(i).numberInliers,0);
end

end

