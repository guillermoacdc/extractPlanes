classdef plane < handle
    %PLANE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        idScene;%scene where the data were acquired
        idFrame;%frame were the data were acquired in the scene
        idPlane;%plane id in the frame 
        idBox;%id of detected box associated with the current plane
        unitNormal;%normal with length 1
        D;%distance to coordinate system qh
        D_qhmov; %distance to the coordinate system qh_movement
        geometricCenter;
        limits;%[xmin xmax ymin ymax zmin zmax]

        composed_idFrame;%just for composed planes
        composed_idPlane;%just for composed planes
        
        pathPoints;%path to 3D points that conform the plane segment (PLY file)
        type;%type of plane {0, parallel; 1, perpendicular; 2 non-expected}
        numberInliers;
        L1;%minimum length of the segment plane (mt)
        L2;%maximum length of the segment plane (mt)
        tform;%pose of the plane. Includes geometric center in column 4
%         Flags
        DFlag;%(0,1) for (distance D out of tolerance region, distance D inside tolerance regin); defined just for parallel planes
        lengthFlag;%(0,1) for (expected length, non expected length)
        antiparallelFlag;% (0,1) for (paralle normal, antiparallel normal)
        topOccludedPlaneFlag;%(0,1) for (non occluded, occluded)
        
        L2toY;%(0, 1) for (L2 is along y axis, L1 is along y axis); just for perpedicular planes
        planeTilt;% (0, 1) for (z-y tilt, x-y tilt); non defined for parallel planes
        secondPlaneID;%perpendicular plane that belongs to the same box that idPlane; empty for non defined. two dimensional [v1, v2]; v1 is the frame index, v2 is the plane index
        thirdPlaneID;%
        nearestPlaneID;
        secondNearestPlaneID;
%         corner parameters
        x1;
        x2;
        y1;
        y2;
%         distance between camera and object;
        distanceToCamera;%in meters
        angleBtwn_zc_unitNormal;%angle btwn z-axis of HL2 camera and unitNormal of the plane; in degrees
        timeParticleID;%id of object particle associated
        fitness;%fitness of the plane
    end
    
    methods
%         constructor
        function obj = plane(scene,frame,pID,modelParameters,pathInliers,Nmbinliers)
            %PLANE Construct an instance of this class
%             Assumptions: normal with unit length
            %   Detailed explanation goes here
            obj.unitNormal = [modelParameters(1) modelParameters(2) modelParameters(3)];
%             obj.unitNormal=obj.unitNormal/norm(obj.unitNormal);%normalize. 
            obj.D = modelParameters(4);
            obj.geometricCenter=[modelParameters(5) modelParameters(6) modelParameters(7)];%this value is updated in method setLimits
            obj.numberInliers=Nmbinliers;
            obj.idScene=scene;%scene where the data were acquired
            obj.idFrame=frame;%frame were the data were acquired in the scene
            obj.idPlane=pID;%plane id in the frame 
            obj.pathPoints=pathInliers;
        end
        
        function ne_flag=classify(obj,pc,th_angle, groundNormal)
            %METHOD1 classify the plane based on two criterion
%               (1) anglebtwn(groundNormal,planeNormal)->{0,1,2}, {parallel to ground, perpendicular to ground, non-expected Plane}
%               (2) inclination of perpendicular planes ->{0,1}, {inclined to x-y axis, inclined to z-y axis} 
            ne_flag=0;
%             th_angle=th_angle*pi/180;
            % compute angle between normal of plane and normal of ground
            alpha=computeAngleBtwnVectors([obj.unitNormal],groundNormal);
            if( abs(cos(alpha*pi/180)) > cos (th_angle))%con abs también va a aceptar antiparalelos
                obj.type=0;%parallel to ground plane
            elseif (abs(cos(alpha*pi/180))< cos (pi/2-th_angle) )%perpendicular to ground plane
                obj.type=1;%perpendicular to ground plane
                % Project points into model plane
                pc_projected=projectInPlane(pc,[obj.unitNormal obj.D]);
                % compute std deviation on x, z
                devx=std(pc_projected.Location(:,1));
                devz=std(pc_projected.Location(:,3));
                % classify as tilted to xy (1) or tilted to zy (0)
                if(devx>=devz)%inclined to x-y axis, %compute angle with normal [0 0 1]
                    obj.planeTilt=1;
                else%inclined to z-y axis, %compute deviation with normal [1 0 0]
                    obj.planeTilt=0;
                end

            else%non expected plane
                obj.type=2;
                ne_flag=1;
            end
            
        end
        
        function correctAntiparallel(obj,th_size)
            obj.antiparallelFlag=0;
            if (obj.type==1)%perpendicular plane
%                 if (obj.D<0 && obj.numberInliers>th_size)%original version
                if (obj.D_qhmov<0 && obj.numberInliers>th_size)%original version                    
                    obj.antiparallelFlag=1;
                end
            else%parallel plane. 
%                 if(obj.D<0 && obj.type==0 )
                if(obj.D_qhmov<0 && obj.type==0 )
                    obj.antiparallelFlag=1;
                end
            end
            
            if(obj.antiparallelFlag==1)
                %Invert orientation and distance's sign
                    obj.unitNormal=-obj.unitNormal;
                    obj.D=-obj.D;
            end
            
        end
        
        function setLimits(obj, pc)
%         Project points into model plane
        pc_projected=projectInPlane(pc,[obj.unitNormal obj.D]);%can avoid some ops if set Limits in classify: double projection in plane
%         compute limits of the projected pc
        obj.limits=[min(pc_projected.Location(:,1)), max(pc_projected.Location(:,1)),...
            min(pc_projected.Location(:,2)),  max(pc_projected.Location(:,2)),...
            min(pc_projected.Location(:,3))  max(pc_projected.Location(:,3))];
%         update geometric center using projected data
        obj.geometricCenter=[mean(pc_projected.Location(:,1),1),...
            mean(pc_projected.Location(:,2),1) mean(pc_projected.Location(:,3),1)];
        end
        
        function measurePoseAndLength(obj, pc, occlussionTreshold, plotFlag, compensateFactor)
        %This method is not defined for obj.type==2
        % Project points into model plane
        pc_projected=projectInPlane(pc,[obj.unitNormal obj.D]);
        
%         compute pose, length and plane tilt; last one just for
%         perpendicular planes
        if (obj.type==0)%parallel planes
           [obj.L1 obj.L2 obj.tform myOccludedIndex]=computeL1L2Parallel(pc_projected,obj,plotFlag);
           if (myOccludedIndex>occlussionTreshold)
               obj.topOccludedPlaneFlag=1;
           end
        else
            if (obj.type==1)%perpendicular planes
                [obj.L1 obj.L2 obj.tform L2toY]=computeL1L2Perpendicular_v2(pc_projected,obj, plotFlag);
                obj.L2toY=L2toY;
%             compensate pose and length - Para sesiones con apilamiento, se debe restringir  la compensación a planos que se soportan en el piso
%             compensate length
                if L2toY==1
                    obj.L2=obj.L2+compensateFactor;
                else
                    obj.L1=obj.L1+compensateFactor;
                end
%           compensate pose
            obj.tform(2,4)=obj.tform(2,4)-(compensateFactor/2);%50% 
            end
        end
        
        end
        
        function setLengthFlag(obj,flag)
            obj.lengthFlag=flag;
        end
        
        function setDFlag(obj,flag)
            obj.DFlag=flag;
        end

        function id=getID(obj)
            id=[obj.idFrame obj.idPlane];
        end

        function setDistanceToCamera(obj, cameraPosition)
%             distanceToCamera_ref=norm(obj.tform(1:3,4)-cameraPosition);
            distanceToCamera_ref=norm(obj.geometricCenter-cameraPosition);
            obj.distanceToCamera=distanceToCamera_ref;
        end

        function setD_qhmov(obj, cameraPosition)
            cameraPostion_movement=cameraPosition(1:3,4);
            obj.D_qhmov=dot([obj.unitNormal(1) obj.unitNormal(2) obj.unitNormal(3)],cameraPostion_movement)+obj.D;
        end

        function setAngleBtwn_zc_unitNormal(obj, zcVector)
            obj.angleBtwn_zc_unitNormal=computeAngleBtwnVectors(obj.unitNormal,zcVector);%degrees
        end
        function setfitness(obj, th_dis)
        %SETFITNESS Computes the fitness of a plane object assuming that
        %the best fitness is related with:
        % (a) objects where the distance to camera is in the range [th_dmin th_dmax].
        % The distance thresholds depends on the sensor, for HL2/depth camera I 
        % suggest: th_dmin=1.5 m, th_dmax=2.5 m 
        % (b) Angle between the axis z in camera and the normal of the plane is 
        % near to 0 or 180 
 
        % deltaPoseCamera=1;
        th_dmin=th_dis(1);%mm
        th_dmax=th_dis(2);%mm
        
        % compute inrange  flag
        dcoinrange=false;
        if obj.distanceToCamera<th_dmax & obj.distanceToCamera>th_dmin
            dcoinrange=true;
        end
        % compute fitness
        if dcoinrange
            if obj.angleBtwn_zc_unitNormal<90
                obj.fitness=1-obj.angleBtwn_zc_unitNormal/90;
                disp('angle lower than 90 from plane.setfitness()')
            else
                obj.fitness=obj.angleBtwn_zc_unitNormal/90-1;
            end
        else
            obj.fitness=0;
        end
        % add the delta camera pose to the fitnness
        % fitness=(1-deltaPoseCamera)*fitness;
        


        end
        function normal_mm=getUnitNormal(obj)
%             returns the normalized normal vector
            normal_mm=obj.unitNormal;
        end
    end
end

