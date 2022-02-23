clc
close all
clear all
% this script computes features of  each detected plane in a frame and save
% those feautres in a txt file.
% 1. L1. minor length of the vertices (cm)
% 2. L2. max length of the vertices (cm)
% 3. normal {0 for parallel to ground planes, 1 for perpendicular to ground planes}

%% load pc
frame=5;
in_planesFolderPath=['C:/lib/outputPlanes_t10/frame ('  num2str(frame)  ')/'];%extracted planes with efficientRANSAC

cd1=cd;
cd(in_planesFolderPath);
Files1=dir('*.ply');
cd(cd1)
numberPlanes=length(Files1);

fid = fopen( 'scene5DetectedPlanes.txt', 'wt' );%planeID boxID L1 L2 normal
for i=2:numberPlanes%plane number 1 is ground plane
%     load plane parameters
    planeID=i;
    [modelParameters pc ]=loadPlaneParameters(in_planesFolderPath, frame, planeID);
% compute plane segment parameters
    groundNormal=[0 1 0];% the height is in axis y
    myTolerance=10;%degrees
    [L1 L2 tform normalType]=measurePlaneParameters(pc, modelParameters, groundNormal, myTolerance,1);
    if(normalType~=3)
        fprintf( fid, '%d,%d,%d\n', 100*L1, 100*L2, normalType~=0);
    end
end
fclose(fid);



