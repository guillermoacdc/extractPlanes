function estimatedPoses=computeEstimatedPosesStruct_v2(globalPlanes_t,gtPoses,...
            sessionID,frameID,estimatedPlanesID,tao_v,dataSetPath,...
            NpointsDiagPpal, estimatedPoses, ProcessingTime)
%COMPUTEESTIMATEDPOSESSTRUCT project estimated poses to qm and compute 
% estimatedPoses struct. 
% 1. Project estimated poses to qm (.tform). The rest of the properties is not
%   modifed
% 2. Computes the struct estimatePoses. This has the next fields by frame:
%     IDObjects: [5×2 double]
%         poses: [5×16 double]
%            L1: [3.4679e+05 3.4515e+05 2.4865e+05 2.8931e+05 2.8621e+05]
%            L2: [4.5451e+05 4.4108e+05 3.2382e+05 3.3701e+05 3.0825e+05]
%      Ninliers: [0 0 0 0 0]
%            dc: [0 0 0 0 0]
%          eADD: [1×1 struct]
            %     tao10: [5×18 double]
            %     tao20: [5×18 double]
            %     tao30: [5×18 double]
            %     tao40: [5×18 double]
            %     tao50: [5×18 double]
%ProcessingTime: x ms

Ntao=length(tao_v);
%% Project estimated poses to qm
        globalPlanes_m.fr0.values=myProjectionPlaneObject_v2(globalPlanes_t,...
            sessionID,dataSetPath);%-m world
        %validation figure
%     if frameID==26
%             pc_i=createSyntheticPC(globalPlanes_m,NpointsDiagPpal, 1);
%             pc=projectPCtoGTPoses(pc_i,globalPlanes_m);
%             figure,
%             pcshow(pc)
%             hold on
%             dibujarsistemaref(eye(4),'m',150,2,10,'w');
%             title(['Projected point clouds in frame ' num2str(frameID)])
%             Nscanned=size(globalPlanes_m.fr0.values,2);
%             for j=1:Nscanned
%                 T=globalPlanes_m.fr0.values(j).tform;
%                 planeID=globalPlanes_m.fr0.values(j).getID;
%                 dibujarsistemaref(T,planeID,150,2,10,'w');
%             end
%     end
%% Computes the struct estimatePoses
        estimatedPoses.(['frame' num2str(frameID)]).IDObjects=estimatedPlanesID;
        [poses, L1e, L2e, dc, Ninliers]=convertToArrays_v2(globalPlanes_m.fr0.values);
        estimatedPoses.(['frame' num2str(frameID)]).poses=poses;
        estimatedPoses.(['frame' num2str(frameID)]).L1=L1e;
        estimatedPoses.(['frame' num2str(frameID)]).L2=L2e;
        estimatedPoses.(['frame' num2str(frameID)]).Ninliers=Ninliers;
        estimatedPoses.(['frame' num2str(frameID)]).dc=dc;
        estimatedPoses.(['frame' num2str(frameID)]).ProcessingTime=ProcessingTime;
        for j=1:Ntao
            tao=tao_v(j);
            logtxt=['Processing with tao= ' num2str(tao)];
            disp(logtxt);
    %         writeProcessingState(logtxt,evalPath,sessionID);
    %         write eADD to the struct
            estimatedPoses.(['frame' num2str(frameID)]).eADD.(['tao' num2str(tao)])=compute_eADD_v2(globalPlanes_m.fr0.values,...
             gtPoses,  tao, dataSetPath, NpointsDiagPpal);
        end
end

