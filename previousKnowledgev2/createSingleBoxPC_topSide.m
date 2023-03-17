function pcBox=createSingleBoxPC_topSide(L1,L2,H,spatialSampling)
    xyz=[];
    % top plane for the first box
    [x,y,z] = ndgrid(0:spatialSampling:L1,  0:spatialSampling:L2,   H);
    xyz=[x(:),y(:),z(:)];
%     [x,y,z] = ndgrid(0:spatialSampling:L1,  0,  0:spatialSampling:H);
%     xyz=[xyz ; [x(:),y(:),z(:)]];

%     put the origin of the box in the top plane - geometric center
    T1=[1 0 0 -L1/2; 0 1 0 -L2/2;0 0 1 -H; 0 0 0 1];

for i=1:size(xyz,1)
    xyza=T1*[xyz(i,:) 1]';
    xyz(i,:)=xyza(1:3)';
end
    pcBox=pointCloud(xyz);
end