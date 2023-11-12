function myBoxes=groups2Boxes_isolated(globalPlanes,group_tpp, group_tp, sessionID,...
            frameID, pkFlag, compensateHeight, th_angle)
%GROUPS2BOXES Computes a set of boxes from groups of plane segments. The groups
% are categorized as triads and couples. 

% initiate vars
newGroup_tp=[];
emptyBoxObject=detectedBox(0,0,0,0,eye(4),[0 0 0],[0 0 0]);

myBoxes1=[emptyBoxObject ];
myBoxes2=[emptyBoxObject ];
myBoxes1(1)=[];
myBoxes2(1)=[];
%% triads to boxes
Ng=length(group_tpp);
if Ng>=1
    for i_box=1:Ng
        splane=globalPlanes.values(group_tpp(i_box));
        secondIndex=splane.secondPlaneID;
        thirdIndex=splane.thirdPlaneID;
        triadIndex=[group_tpp(i_box), secondIndex, thirdIndex];
        [tempBox, tempGroup_tp]=triad2Boxes(globalPlanes.values,triadIndex, ...
            sessionID, frameID, pkFlag,i_box, compensateHeight, th_angle); 
        myBoxes1(i_box)=tempBox;
        newGroup_tp=[newGroup_tp, tempGroup_tp];
%         display associations
        triadID=[splane.idFrame, splane.idPlane, ...
            globalPlanes.values(secondIndex).idFrame, globalPlanes.values(secondIndex).idPlane...
            globalPlanes.values(thirdIndex).idFrame, globalPlanes.values(thirdIndex).idPlane];
        disp(['                    splane ' num2str(triadID(1)) '-' num2str(triadID(2))...
            ' is associated with splane ' num2str(triadID(3)) '-' num2str(triadID(4)),...
            ' and splane ' num2str(triadID(5)) '-' num2str(triadID(6))])
    end
end
Nb1=length(myBoxes1);
%% couples to boxes
% add couples descarted from triad2Boxes
if ~isempty(newGroup_tp)
    group_tp=[group_tp newGroup_tp];
end
% process couples
Ng=length(group_tp);
if Ng>=1
    for i_box=1:Ng
        splane=globalPlanes.values(group_tp(i_box));
        secondIndex=splane.secondPlaneID;
        coupleIndex=[group_tp(i_box), secondIndex ];
        myBoxes2(i_box)=couple2Boxes_isolated(globalPlanes.values,coupleIndex, sessionID,...
            frameID, pkFlag, i_box+Nb1, compensateHeight, th_angle); 

%         display associations
%         coupleID=[splane.getID(), globalPlanes.values(secondIndex).getID];
        coupleID=[splane.idFrame(), splane.idPlane(), globalPlanes.values(secondIndex).idFrame, globalPlanes.values(secondIndex).idPlane];
        disp(['                    splane ' num2str(coupleID(1)) '-' num2str(coupleID(2))...
            ' is associated with splane ' num2str(coupleID(3)) '-' num2str(coupleID(4)),...
        ])
    end
end
%% join boxes
myBoxes=[myBoxes1 myBoxes2];
% eliminate empty box objects
Ngb=length(myBoxes);
indexToEliminate=[];
for k=1:Ngb
    if myBoxes(k).id==0
        indexToEliminate=[indexToEliminate k];
    end
end
myBoxes(indexToEliminate)=[];
end

