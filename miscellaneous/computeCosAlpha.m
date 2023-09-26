function cosAlpha = computeCosAlpha(pc,refNormal)
%COMPUTECOSALPHA Computes the abs(cos) of the angle btwn the normal of each
%point and the ref normal vector
%   Detailed explanation goes here

normalV=pcnormals(pc);
alpha=zeros(pc.Count,1);
for i=1:pc.Count
    P1=normalV(i,:);
    alpha(i)=computeAngleBtwnVectors(P1,refNormal);
end
cosAlpha=abs(cos(alpha*pi/180));%angle in radians
end

