function box = compute6DBoxPose(indexGroup,globalPlanes, sideBoxID)
%COMPUTE6DBOXPOSE computes the 6D pose of a box conformed by plane
%segments in glboalPlanes and pointed by indexGroup
%   Detailed explanation goes here
box.t=globalPlanes.values(indexGroup(1)).tform(1:3,4);
box.R=globalPlanes.values(indexGroup(1)).tform(1:3,1:3);


Nlatsides=length(sideBoxID)-1;
% if Nlatsides>1
%     disp('stop')
% end
yawLateral=zeros(Nlatsides,1);
topsideIndex=indexGroup(1);
for i=2:Nlatsides+1
    if sideBoxID(i)==1 | sideBoxID(i)==3
        %computes angle btwn xtop and xside1_p
        tempIndex=find(sideBoxID==1);
        if isempty(tempIndex)
            tempIndex=find(sideBoxID==3);
        end
        side1Index=indexGroup(tempIndex);
        yawLateral(i-1)=computeYawSide1(globalPlanes.values,topsideIndex, side1Index);
    else
        %computes angle btwn ztop and -xside2_p
        tempIndex=find(sideBoxID==2);
        if isempty(tempIndex)
            tempIndex=find(sideBoxID==4);
        end
        side2Index=indexGroup(tempIndex);
        yawLateral(i-1)=computeYawSide2(globalPlanes.values,topsideIndex, side2Index);
%         yawLateral(i)=computeYawP2(globalPlanes.values,indexGroup);
    end
end
% yaw_top=computeAngleBtwnVectors([0 0 1],box.R(:,3));
% yaw_offset=(yaw_top-mean(yawLateral))/2;%put equal weights to lateral and top yaws
yaw_offset=mean(yawLateral)/2;
box.R=roty(yaw_offset)*box.R;
end

