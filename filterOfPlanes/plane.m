classdef plane < handle
    %PLANE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A;%x component of the normal
        B;%y component of the normal
        C;%z component of the normal
        D;%distance
        type;%type of plane {0, parallel; 1, perpendicular; 2 non-expected}
        numberInliers;
        L1;%minimum length of the segment plane (mt)
        L2;%maximum length of the segment plane (mt)
        tform;%pose of the plane. Includes geometric center in column 4
        lengthFlag;%(0,1) for (non expected length, expected length)
        antiparallelFlag;% (0,1) for (paralle normal, antiparallel normal)
        planeTilt;% (0, 1) for (z-y tilt, x-y tilt); non defined for parallel planes
        geometricCenter;
        limits%[xmin xmax ymin ymax zmin zmax]
    end
    
    methods
        function obj = plane(in1,in2,in3,in4,in5)
            %PLANE Construct an instance of this class
            %   Detailed explanation goes here
            obj.A = in1;
            obj.B = in2;
            obj.C = in3;
            obj.D = in4;
            obj.numberInliers=in5;
        end
        
        function ne_flag=classify(obj,pc,th_angle, groundNormal)
            %METHOD1 compute the type of normal  by comparing with the normal
%of the ground
            ne_flag=0;
            th_angle=th_angle*pi/180;
            % compute angle between normal of plane and normal of ground
            alpha=computeAngleBtwnVectors([obj.A obj.B obj.C],groundNormal);
            if( abs(cos(alpha*pi/180)) > cos (th_angle))%con abs también va a aceptar antiparalelos
                obj.type=0;%parallel to ground plane
            elseif (abs(cos(alpha*pi/180))< cos (pi/2-th_angle) )%perpendicular to ground plane
                obj.type=1;%perpendicular to ground plane
                % Project points into model plane
                pc_projected=projectInPlane(pc,[obj.A obj.B obj.C obj.D]);
                % compute std deviation on x, z
                devx=std(pc_projected.Location(:,1));
                devz=std(pc_projected.Location(:,3));
                % classify as tilt to xy (1) or tilt to zy (0)
                if(devx>=devz)%inclined to x-y axis, %compute angle with normal [1 0 0]
                    obj.planeTilt=1;
                else%inclined to z-y axis, %compute deviation with normal [0 0 1]
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
                obj.A=-obj.A;
                obj.B=-obj.B;
                obj.C=-obj.C;
                obj.D=-obj.D;
        end
        
        end
        
        function setGeometricCenter(obj, pc)
%         Project points into model plane
        pc_projected=projectInPlane(pc,[obj.A obj.B obj.C obj.D]);
%         compute geometric center of the projected pc
        obj.geometricCenter=[mean(pc_projected.Location(:,1),1),...
            mean(pc_projected.Location(:,2),1) mean(pc_projected.Location(:,3),1)];
%         compute limits of the projected pc
        obj.limits=[min(pc_projected.Location(:,1)), max(pc_projected.Location(:,1)),...
            min(pc_projected.Location(:,2)),  max(pc_projected.Location(:,2)),...
            min(pc_projected.Location(:,3))  max(pc_projected.Location(:,3))];
        end
        
        function measurePoseAndLength(obj, pc, plotFlag)
%         Project points into model plane
        pc_projected=projectInPlane(pc,[obj.A obj.B obj.C obj.D]);
        
%         compute pose, length and plane tilt; last one just for
%         perpendicular planes
        if (obj.type==0)%parallel planes
            [obj.L1 obj.L2 obj.tform]=computeL1L2Parallel(pc_projected,obj,plotFlag);
        else
            if (obj.type==1)%perpendicular planes
                [obj.L1 obj.L2 obj.tform ]=computeL1L2Perpendicular(pc_projected,obj, plotFlag);
%                 obj.planeTilt=xyFlag;
            end
        end
        %note that the geometric center is in tform, column 4
        end
        
        function setLengthFlag(obj,flag)
            obj.lengthFlag=flag;
        end
        
    end
end

