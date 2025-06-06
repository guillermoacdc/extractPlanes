classdef plane < handle
    %PLANE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        idScene;%scene where the data were acquired
        idFrame;%frame were the data were acquired in the scene
        idPlane;%plane id in the frame 
        idBox;%id of detected box associated with the current plane
        unitNormal;%normal with length 1
        D;%distance
        geometricCenter;
        limits;%[xmin xmax ymin ymax zmin zmax]

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
%         corner parameters
        x1;
        x2;
        y1;
        y2;
%         area;
        
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
            if (obj.D<0 && obj.numberInliers>th_size)
                obj.antiparallelFlag=1;
            end
        else%parallel plane. 
            if(obj.D<0 && obj.type==0 )
                obj.antiparallelFlag=1;
            end
        end
        
        if(obj.antiparallelFlag)
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
        
        function measurePoseAndLength(obj, pc, occlussionTreshold, plotFlag)
%This method is not defined for obj.type==2
%         Project points into model plane
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
    end
end

