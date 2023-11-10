myDisplayGroups(globalPlanes.values, group_tpp, group_tp, group_s);
figure,
    myPlotPlanes_v3(globalPlanes.values,1);
    title(['global planes  previous in frame ' num2str(frameID-1)])
    
i_box=3;
topPlane=globalPlanes.values(group_tp(i_box));
secondIndex=topPlane.secondPlaneID;
coupleIndex=[group_tp(i_box), secondIndex];
disp(['couple composed by planes ' num2str(globalPlanes.values(coupleIndex(1)).getID)...
    ' , ' num2str(globalPlanes.values(coupleIndex(2)).getID)])


estimatedSyntheticPlane = computeEstimatedSyntheticLateralPlane(globalPlanes.values,...
            coupleIndex, sessionID, frameID);
figure,
    myPlotPlanes_v3(globalPlanes.values(coupleIndex(1)),1)
    myPlotPlanes_v3(globalPlanes.values(coupleIndex(2)),1)
    dibujarsistemaref(estimatedSyntheticPlane.tform,'s',150,2,10,'w')

figure,    
Ng=length(group_tp);
if Ng>1
    for i_box=1:Ng
        topPlane=globalPlanes.values(group_tp(i_box));
        secondIndex=topPlane.secondPlaneID;
        coupleIndex=[group_tp(i_box), secondIndex];
        estimatedSyntheticPlane = computeEstimatedSyntheticLateralPlane(globalPlanes.values,...
            coupleIndex, sessionID, frameID);
            myPlotPlanes_v3(globalPlanes.values(coupleIndex(1)),1)
            myPlotPlanes_v3(globalPlanes.values(coupleIndex(2)),1)
            dibujarsistemaref(estimatedSyntheticPlane.tform,'s',150,2,10,'w');
    end
end

L1=estimatedSyntheticPlane.L1;
L2=estimatedSyntheticPlane.L2;
pc=createSyntheticPCFromDetection(estimatedSyntheticPlane,30,1,L1,L2);
pcshow(pc)