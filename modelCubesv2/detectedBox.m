classdef detectedBox < handle
    %DETECTEDBOX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;%box id
        depth;
        height;
        width;
        tform;% with origin in center of top plane
        planesID;% vector with ids of planes that conform the box. size 1x6: [p11 p12 p21 p22 p31 p32]
        sidesID;% vector with ID of side corresponde to each plane ID to see the side codification open computeSidesInTriad.m
    end
    
    methods
        function obj = detectedBox(id, depth, height,width, tform, planesID, sidesID)
            %DETECTEDBOX Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = id;
            obj.depth = depth;
            obj.height = height;
            obj.width = width;
            obj.tform = tform;
            obj.planesID=planesID;
            obj.sidesID=sidesID;
        end
        
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

