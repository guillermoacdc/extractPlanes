function scene = extractSceneFromVector(globalPlanes)
%EXTRACTSCENEFROMVECTOR Summary of this function goes here
%   Detailed explanation goes here
Np=length(globalPlanes);
scene=ones(Np,1);
for i=1:Np
    scene(i)=globalPlanes(i).idScene;
end
end

