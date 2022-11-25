function double2singlePCs_vtext(sceneNumber, pathToDoublePointClouds, ...
    pathToFramesID, pathToSinglePointClouds)
% function to transform a set of point clouds with double precision to
% another set of point clouds with single precision. The set of point
% clouds belong to a single scene from the packing application

% inputs
% 1. sceneNumber
% 2. pathToDoublePointClouds
% 3. frames of interest
% 4. pathToSinglePointClouds

% outputs
% 1. pointClouds with single precision in the predefined path



% create the output folder
cd1=cd;
cd(pathToSinglePointClouds);
mkdir (['singlePC/'])

%load name of the involved ply files
% cd1=cd;
cd(pathToDoublePointClouds);
Files=dir('*.ply');
cd(cd1)
pathToDoublePointClouds=['~/Documents/boxesDatabaseSample/corrida'  num2str(sceneNumber)  '/"Depth Long Throw"/'];

% load init and final frame 
framesOfInterest=importdata(pathToFramesID);
framesOfInterest=framesOfInterest(2:end);
framesOfInterest=reshape(framesOfInterest,[3,length(framesOfInterest)/3])';
% put the cmd in the output folder
% command1=['cd ' pathToSinglePointClouds];
% command2=['pdal --version'];
% [status,cmdout] = system([command1 ';' command2])
% pause(1)

fid = fopen( ['scriptToConvertPLYs_scene' num2str(sceneNumber) '.txt'], 'wt' );



% perform the conversion


N=size(framesOfInterest,1);
for i=1:N
    finit=framesOfInterest(i,2);
    fend=framesOfInterest(i,3);
    for j=finit:fend
        fileName_ply=Files(j).name;
        
%         command3= ['pdal translate ' + pathToDoublePointClouds + fileName_ply + ' ' + 'frame' + num2str(j) + '.ply --writers.ply.dims="X=float32,Y=float32,Z=float32"'];
        command3= ['pdal translate ' pathToDoublePointClouds fileName_ply ' '  'frame' num2str(j) '.ply --writers.ply.dims="X=float32,Y=float32,Z=float32"'];
%         disp(['conversion of frame ' num2str(j) ' which has as name: ' fileName_ply ' with command/n'])
        disp([num2str(j) ' ---> ' fileName_ply '/n'])
        disp(command3);
        fprintf( fid, '%s\n', command3);
%         [status,cmdout] = system(command3)
%         pause(1)
    end
   
end
fclose(fid);
end



