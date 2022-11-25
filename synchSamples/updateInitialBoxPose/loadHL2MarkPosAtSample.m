function position = loadHL2MarkPosAtSample(scene,rootPath,sample, markerIDs)
%LOADHL2MARKPOSATSAMPLE load HL2 Markers position at an specefic sample
%   Detailed explanation goes here

%% create fileName and define marker IDs
append=computeAppend(scene);
fileName=['corrida' num2str(scene) '-00' num2str(append)];
% markerIDs=[0 3 4 5 6];%markers associated with the HL2


%% Load OpenSim libs
import org.opensim.modeling.*
%% Get the path to a C3D file
% mocap_path = rootPath + 'scene' + num2str(scene) + '\mocap\';
mocap_path = rootPath + 'corrida' + num2str(scene) + '\mocap\';

c3dpath = fullfile(mocap_path,[fileName '.c3d']);
%% Construct an opensimC3D object with input c3d path
% Constructor takes full path to c3d file and an integer for forceplate
% representation (1 = COP).
c3d = osimC3D(c3dpath,1);
%% Get the c3d in structure form
markerStruct = c3d.getAsStructs();
%% extract data from markerIDs as a new structure
for j=1:length(markerIDs)
    if(markerIDs(j)<10)
        eval(['position.M00' num2str(markerIDs(j)) '=markerStruct.M00' num2str(markerIDs(j)) '(sample,:);' ]);
    else
        if (markerIDs(j)<100)
            eval(['position.M0' num2str(markerIDs(j)) '=markerStruct.M0' num2str(markerIDs(j)) '(sample,:);' ]);  
        else
            eval(['position.M' num2str(markerIDs(j)) '=markerStruct.M' num2str(markerIDs(j)) '(sample,:);' ]);
        end    
    end
end
position.time=markerStruct.time(sample,:);



end

