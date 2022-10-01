function pcBox=createSingleBoxPC(L1,L2,H,spatialSampling, angle)
    % top plane for the first box
    [x,y,z] = ndgrid(0:spatialSampling:L1,  0:spatialSampling:L2,   H);
    xyz=[x(:),y(:),z(:)];
%     pcTop=pointCloud(xyz);

if angle>45    
    % side four of the box
    [x,y,z] = ndgrid(0:spatialSampling:L1,  L2,  0:spatialSampling:H);
    xyz=[xyz ; [x(:),y(:),z(:)]];
else
    % side one of the box 
    [x,y,z] = ndgrid(0:spatialSampling:L1,  0,  0:spatialSampling:H);
end
xyz=[xyz ; [x(:),y(:),z(:)]];

    
if angle<-45   
    % side three of the box
    [x,y,z] = ndgrid(L1, 0:spatialSampling:L2,   0:spatialSampling:H);
else
    % side two of the box
    [x,y,z] = ndgrid(0, 0:spatialSampling:L2,   0:spatialSampling:H);
end
xyz=[xyz ; [x(:),y(:),z(:)]];

% 




%     put the origin of the box in the top plane - geometric center
    T1=[1 0 0 -L1/2; 0 1 0 -L2/2;0 0 1 -H; 0 0 0 1];

for i=1:size(xyz,1)
    xyza=T1*[xyz(i,:) 1]';
    xyz(i,:)=xyza(1:3)';
end

    pcBox=pointCloud(xyz);
end