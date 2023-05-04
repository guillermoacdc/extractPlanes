classdef particle < handle
    %PARTICLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;%property id
        position;%3D position
        ninliers;%number of inliers
        distanceCameraObject;
        historicPresence;%binary vector with a flag of presence in each frame [frameID presenceFlag]
    end
    
    methods
        function obj = particle(id_ref,pos_ref, ninliers_ref, dco_ref, frameID_ref)
            %PARTICLE Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = id_ref;
            obj.position=pos_ref;
            obj.ninliers=ninliers_ref;
            obj.distanceCameraObject=dco_ref;
            obj.historicPresence=[frameID_ref, 1];
        end
        
        function setPosition(obj, pos_ref)
            obj.position=pos_ref;
        end

        function position = getPosition(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            position = obj.position;
        end

        function setNinliers(obj, ninliers_ref)
            obj.ninliers=ninliers_ref;
        end

        function Ninliers= getNinliers(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            Ninliers = obj.ninliers;
        end

        function setDCO(obj, dco_ref)
            obj.distanceCameraObject=dco_ref;
        end

        function dco = getDCO(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            dco = obj.distanceCameraObject;
        end

        function myPush(obj,frameID_ref, value_ref)
            obj.historicPresence(end+1,:)=[frameID_ref, value_ref];%push
        end
    end
end

