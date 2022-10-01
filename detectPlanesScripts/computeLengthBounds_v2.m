function [lengthBoundsTop, lengthBoundsP] = computeLengthBounds_v2(rootPath, scene)
%COMPUTELENGTHBOUNDS compute length bounds for expected planes in the
%scene. 
% C:\lib\boxTrackinPCs\scene5\previousKnowledgeFile.txt
% load previous knowledge of the scene: number of boxes, size of each box
% and physical packing sequence

parameters = loadLengths(rootPath,scene);%length in mm
% parameters=load(fileName);%boxId, typeID, H(3) W(4) D(5)
NoBoxes=size(parameters,1);


% convert boxes descriptors to planes descriptors
planeID=1;  
planeDescriptor=zeros(NoBoxes*3,5);
% iterative
for i=1:NoBoxes
%     if i==7
%         disp("stop the code");
%     end
    % read box parameters
    W=parameters(i,3)/10;%Convert to cm
    D=parameters(i,2)/10;
    H=parameters(i,4)/10;
    % compute faces 1 to 3 from parameters
    [facexz faceyz facexy] = createBoxPCv4(W,D,H);
    % store plane parameters
    boxID=parameters(i,1);
    planeDescriptor(planeID,:)=[planeID boxID facexz.L1 facexz.L2 facexz.normal];
    planeID=planeID+1;
    planeDescriptor(planeID,:)=[planeID boxID faceyz.L1 faceyz.L2 faceyz.normal];
    planeID=planeID+1;
    planeDescriptor(planeID,:)=[planeID boxID facexy.L1 facexy.L2 facexy.normal];
    planeID=planeID+1;
end
% separate top and perpendicular planes
planeDescriptorTop=zeros(NoBoxes,5);
planeDescriptorPerpendicular=zeros(NoBoxes*2,5);
k1=1;
k2=1;
for i=1:size(planeDescriptor,1)
    if planeDescriptor(i,5)==0
        planeDescriptorTop(k1,:)=planeDescriptor(i,:);
        k1=k1+1;
    else
        planeDescriptorPerpendicular(k2,:)=planeDescriptor(i,:);
        k2=k2+1;
    end
end

% compute length bounds from plane descriptors
    L1max=max(planeDescriptorTop(:,3));
    L2max=max(planeDescriptorTop(:,4));
    L1min=min(planeDescriptorTop(:,3));
    L2min=min(planeDescriptorTop(:,4));
    lengthBoundsTop=[L1min L1max L2min L2max];

    L1max=max(planeDescriptorPerpendicular(:,3));
    L2max=max(planeDescriptorPerpendicular(:,4));
    L1min=min(planeDescriptorPerpendicular(:,3));
    L2min=min(planeDescriptorPerpendicular(:,4));
    lengthBoundsP=[L1min L1max L2min L2max];

end

