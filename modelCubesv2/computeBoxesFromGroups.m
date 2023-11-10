function globalBoxes=computeBoxesFromGroups(globalPlanes,group_tpp,...
    group_tp, group_s, sessionID, frameID)
%COMPUTEBOXESFROMGROUPS Compute the vector globalBoxes from groups of plane
%segments that belong to the global map. The groups can be conformed by
%couples of triads of plane segments

% create and initilize vector of detectedBox objects
emptyBoxObject=detectedBox(0,0,0,0,eye(4),[0 0 0],[0 0 0]);
globalBoxes=[emptyBoxObject ];
globalBoxes1=[emptyBoxObject ];
globalBoxes2=[emptyBoxObject ];
    globalBoxes(1)=[];
    globalBoxes1(1)=[];
    globalBoxes2(1)=[];


% compute boxes from groups of triads
Ng=length(group_tpp);
if Ng>1
    for i_box=1:Ng
        splane=globalPlanes.values(group_tpp(i_box));
        secondIndex=splane.secondPlaneID;
        thirdIndex=splane.thirdPlaneID;
        triadID=[splane.getID(), globalPlanes.values(secondIndex).getID, globalPlanes.values(thirdIndex).getID];
        disp(['                    splane ' num2str(triadID(1)) '-' num2str(triadID(2))...
            ' is associated with splane ' num2str(triadID(3)) '-' num2str(triadID(4)),...
            ' and splane ' num2str(triadID(5)) '-' num2str(triadID(6))])
%                 boxID=i_box;
        triadIndex=[group_tpp(i_box), secondIndex thirdIndex];
%                 globalBoxes(i_box)=createBoxObject_vtriads(globalPlanes.values,triadIndex, sessionID, frameID); 
        globalBoxes1(i_box)=createBoxObject_vcuboids_v2(globalPlanes.values,triadIndex, sessionID, frameID); 
    end
end

% compute boxes from groups of couples
Ng=length(group_tp);
if Ng>1
    for i_box=1:Ng
        splane=globalPlanes.values(group_tp(i_box));
        secondIndex=splane.secondPlaneID;
        coupleID=[splane.getID(), globalPlanes.values(secondIndex).getID];
        disp(['                    splane ' num2str(coupleID(1)) '-' num2str(coupleID(2))...
            ' is associated with splane ' num2str(coupleID(3)) '-' num2str(coupleID(4)),...
        ])
        coupleIndex=[group_tp(i_box), secondIndex ];
%                 globalBoxes(i_box)=createBoxObject_vtriads(globalPlanes.values,coupleIndex, sessionID, frameID); 
        globalBoxes2(i_box)=createBoxObject_vcuboids_v2(globalPlanes.values,coupleIndex, sessionID, frameID); 
    end
end
globalBoxes=[globalBoxes1 globalBoxes2];
% eliminate empty box objects
Ngb=length(globalBoxes);
indexToEliminate=[];
for k=1:Ngb
    if globalBoxes(k).id==0
        indexToEliminate=[indexToEliminate k];
    end
end
globalBoxes(indexToEliminate)=[];


end

