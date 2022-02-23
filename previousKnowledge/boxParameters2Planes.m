clc
close all
clear
% This script converts a file (scene5.txt) to a set of parameters of planes
% (in the file scene5Parameters.txt). 
% The input file is composed by descriptors of the boxes in a single scene
% with the format boxId, typeID Height(3) Width(4) Depth(5)
% The output file is composed by descriptors of the planes f1 to f3
% expected in the input scene. f1 and f2 correspond to lateral and
% consecutive faces of a box. f3 corresponds to the top face of a box. the
% format of the output is as follows: planeID, boxID, L1, L2, normal
% three planes (planeIDs) belongs to a single box ID
% L1 is always less or equal than L2
% the normal is codificated with two values: {0 for parallel to ground planes, 
% 1 for perpendicular to ground planes}

% Author: Guillermo Camacho


parameters=load('scene5.txt');%boxId, typeID H(3) W(4) D(5)
NoBoxes=size(parameters,1);

planeID=1;  
fid = fopen( 'scene5Planes.txt', 'wt' );%planeID boxID L1 L2 normal
for i=1:NoBoxes
    % read box parameters
    W=parameters(1,4);
    D=parameters(1,5);
    H=parameters(1,3);
    % compute faces 1 to 3 from parameters
    [face1 face2 face3] = createBoxPCv4(W,D,H);
    % write plane parameters
    boxID=parameters(i,1);
    for j=1:3
        eval([' fprintf( fid, ''%d,%d,%f,%f,%d\n'', planeID, boxID, face' num2str(j),...
            '.L1, face' num2str(j) '.L2, face' num2str(j) '.normal); ']);
    planeID=planeID+1;
    end
    
end
fclose(fid);
return







% k=1;%planes index
% fprintf( fid, '%d,%d,%f,%f,%d\n', k, parameters(1,1), face1.L1, face1.L2, face1.normal);
% 
% fclose(fid);