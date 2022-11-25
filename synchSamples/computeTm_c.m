function T=computeTm_c(scene, sample, rootPath)
% This function computes the transformation matrix  Tm_c for each element in the 
% vector sample. The computation is based on a processing squence over the 
% markers position in the hololens. The function returns a single matrix for each sample, in
% a flat format vector with 1 row, 12 columns. Each columns is a component
% of the transformation matrix in the sequence:
% r11 r12 r13 px r21 r22 r23 py r31 r32 r33 pz


T=zeros(length(sample),12);
append=computeAppend(scene);
fileName=['corrida' num2str(scene) '-00' num2str(append)];
markerIDs=[0 3 4 5 6];%markers associated with the HL2

maxDistance=5;%5mm is the max distance between fitted plane and inliers
offset=-pi/6;%angle between raw plane and alligned plane
VLC_HL2=[-5 -35 164.5 1]';%Distance between l6 vector and VLC camera in HL2 in mm


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
for j=1:size(markerIDs,2)
    if(markerIDs(j)<10)
        eval(['rawMarkers.M00' num2str(markerIDs(j)) '=markerStruct.M00' num2str(markerIDs(j)) '(sample,:);' ]);
    else
        if (markerIDs(j)<100)
            eval(['rawMarkers.M0' num2str(markerIDs(j)) '=markerStruct.M0' num2str(markerIDs(j)) '(sample,:);' ]);  
        else
            eval(['rawMarkers.M' num2str(markerIDs(j)) '=markerStruct.M' num2str(markerIDs(j)) '(sample,:);' ]);
        end    
    end
end
rawMarkers.time=markerStruct.time(sample,:);

interpolatedMarkers=interpolateMarkersByChannel(rawMarkers, markerIDs);

for i=1:length(sample)
    frame=i;
    [rawPlane, ~, ~]=myFitPlane(interpolatedMarkers(:,:,frame),maxDistance);%--ok
    tform = computeT_rotArbitrayAxis(interpolatedMarkers(:,5,frame), interpolatedMarkers(:,1,frame), offset);%rotation around l60 segment
    aPlane=rawPlane.Parameters*pinv(tform);%alligned Plane
    Taux=computeTransformation(interpolatedMarkers(:,:,frame), rawPlane, aPlane, tform, VLC_HL2);
    T(i,:)=[Taux(1,:) Taux(2,:) Taux(3,:)];
end
end