function [composedPlane, bufferCP]=combineCommonType4(planeA, planeB, bufferCP, tresholdsV,...
    planeModelParameters, lengthBoundsTop,gridStep,...
    lengthBoundsP, compensateFactor)
%PERFORMSINGLEMERGE performs a merge between planes that belong to the same
%frame. 
%   Detailed explanation goes here
sessionID=planeA.idScene;
th_lenght=tresholdsV(1);
th_size=tresholdsV(2);
th_occlusion=tresholdsV(4);
maxDistance=planeModelParameters(1);



    %%   compute the new point cloud
        pcA=myPCreadComposedPlane(planeA.pathPoints, planeA.idFrame, planeA.idPlane, bufferCP);
        pcB=myPCreadComposedPlane(planeB.pathPoints, planeB.idFrame, planeB.idPlane, bufferCP);
        pcnew=pcmerge(pcA,pcB,gridStep);%mm
    %%   add components to the bufferCP vector
        Ncomp=computeMaxNcomposedIDPlane(bufferCP);
        bufferCP = updateBufferCP(planeA,planeB, bufferCP, Ncomp);
%        create composed plane
        model = pcfitplane(pcnew,maxDistance);

        newParameters=[model.Parameters 0, 0, 0]; %is assumed that the geometric center will be
 
    %   create a new composed plane, with double value in its IDs

%         condiciona el almacenamieto de pathPoints. En caso de que planeX
%         sea compuesto, recuperar los componentes y armar un cell único.
%         Esto para que la función soft de carga de PCs opere
        newPath = computePathMergedPlane(planeA.pathPoints,planeB.pathPoints);
        composedPlane=plane(sessionID,0,...
                Ncomp+1,newParameters,...
                newPath,pcnew.Count);
        % classify the plane object
            % inherit basic properties
                composedPlane.type=planeB.type;
                if composedPlane.type==1
                    composedPlane.L2toY=planeB.L2toY;
                    composedPlane.planeTilt=planeB.planeTilt;
                end
                composedPlane.D_qhmov=planeB.D_qhmov;
                % set limits and update geometric center. The update is necessary to include the projection of points to
                %     the plane model before compute g.c. 
                composedPlane.setLimits(pcnew);%set limits in each axis.
                %     detect antiparallel normals and correct
                composedPlane.correctAntiparallel(th_size);%
                % measure pose and length, and updata occlusion flag
                composedPlane.measurePoseAndLength(pcnew, th_occlusion, 0, compensateFactor);
                % set length flag based on type of plane
                if composedPlane.type==0
                    lengthFlag=lengthFilter(composedPlane,lengthBoundsTop,th_lenght);
                else
                    lengthFlag=lengthFilter(composedPlane,lengthBoundsP,th_lenght);
                end
                composedPlane.setLengthFlag(lengthFlag);
%       compute the mean fitness
                composedPlane.fitness=mean([planeA.fitness,planeB.fitness]);
%             add relationship with particle element
            composedPlane.timeParticleID=planeB.timeParticleID;                


end

