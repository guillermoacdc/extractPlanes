clc
close all
clear 

% This script plot specific marker trayectories in the space

% 1. define parameters: number of marker, number of scene, rootPath
% rootPath="C:\lib\boxTrackinPCs\";
rootPath="G:\Mi unidad\boxesDatabaseSample";
scene=8;
append=computeAppend(scene);
fileName=['corrida' num2str(scene) '-00' num2str(append)];
markerIDs=[0 3 4 5 6];%markers associated with the HL2
% 2. load data: spatial coordinates for each marker
% Load OpenSim libs
import org.opensim.modeling.*
% Get the path to a C3D file
% mocap_path = rootPath + 'scene' + num2str(scene) + '\mocap\';
mocap_path = rootPath + '\corrida' + num2str(scene) + '\mocap\';
c3dpath = fullfile(mocap_path,[fileName '.c3d']);
% Construct an opensimC3D object with input c3d path
% Constructor takes full path to c3d file and an integer for forceplate
% representation (1 = COP).
c3d = osimC3D(c3dpath,1);
% Get the c3d in structure form
markerStruct = c3d.getAsStructs();

for j=1:size(markerIDs,2)
    if(markerIDs(j)<10)
        eval(['rawMarkers.M00' num2str(markerIDs(j)) '=markerStruct.M00' num2str(markerIDs(j)) ';' ]);
    else
        if (markerIDs(j)<100)
            eval(['rawMarkers.M0' num2str(markerIDs(j)) '=markerStruct.M0' num2str(markerIDs(j)) ';' ]);  
        else
            eval(['rawMarkers.M' num2str(markerIDs(j)) '=markerStruct.M' num2str(markerIDs(j)) ';' ]);
        end    
    end
end
rawMarkers.time=markerStruct.time;

interpolatedMarkers=interpolateMarkersByChannel(rawMarkers, markerIDs);
% 3. sort data
seconds=15;
t=seconds*960;

N=size(interpolatedMarkers);
for j=1:length(markerIDs)
    % sort raw data
    marker=markerIDs(j);
    xyz=rawMarkers.(['M00' num2str(marker)]);
    pc_raw=pointCloud(xyz(1:t,:));
    
    % sort interpolated
    xyz=zeros(N(3),3);
    for i=1:N(3)
        xyz(i,:)=[interpolatedMarkers(1,j,i), interpolatedMarkers(2,j,i),...
            interpolatedMarkers(3,j,i)];
    end
    pc_int=pointCloud(xyz(1:t,:));
    % 4. plot data
    figure,
    subplot(211),...
        pcshow(pc_int)
        grid on
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
        title  (['Interpolated trayectories of marker M' num2str(marker) ' -  in the scene ' num2str(scene) ' first ' num2str(seconds) ' seconds'])
        view(35,30)
    subplot(212),...
        pcshow(pc_raw)
        grid on
        xlabel 'x'
        ylabel 'y'
        zlabel 'z'
        title  (['Raw trayectories of marker M' num2str(marker) ' -  in the scene ' num2str(scene) ' first ' num2str(seconds) ' seconds'])
        view(35,30)
end