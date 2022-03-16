clc
close all
clear all

%load the names of the ply files associated with scene 5
scene=15;
sourcePath=['~/Documents/boxesRGBDDatabase_valfa/corrida'  num2str(scene)  '/Depth Long Throw'];
cd1=cd;
cd(sourcePath);
Files=dir('*.ply');
cd(cd1)
NbFrames=length(Files);


%identify names for frames 2-9--(target box = 13)

%% from terminal
%put the terminal in the path to save the singlePCs
pathSinglePCs=[cd1 '/singlePCs/scene' num2str(scene) '/'];
myFolder=(["/home/gacamacho/Documents/boxesRGBDDatabase_valfa/corrida" + num2str(scene) + "/'Depth Long Throw'/"]);
command1=['cd ' pathSinglePCs];
command2=['pwd'];
[status,cmdout] = system([command1 ';' command2])

pause(1)
for i=5:43
    fileName_ply=Files(i).name;  
    command3= ['pdal translate ' + myFolder + fileName_ply + ' ' + 'frame' + num2str(i) + '.ply --writers.ply.dims="X=float32,Y=float32,Z=float32"'];
%     [status,cmdout] = system([command1 ';' command3])
    [status,cmdout] = system([ command3])
    pause(1)
end


return
fid = fopen( ['scriptToConvertPLYs_scene' num2str(scene) '_box13.txt'], 'wt' );
fprintf( fid, '%s\n', command1);
fprintf( fid, '%s\n', command3);
myFolder=(["/home/gacamacho/Documents/boxesRGBDDatabase_valfa/corrida" + num2str(scene) + "/'Depth Long Throw'/"]);
for i=5:43
    fileName_ply=Files(i).name;  
%     command4= ['pdal translate ' + myFolder + fileName_ply + ' ' + fileName_ply + ' --writers.ply.dims="X=float32,Y=float32,Z=float32"'];
    command4= ['pdal translate ' + myFolder + fileName_ply + ' ' + 'frame' + num2str(i) + '.ply --writers.ply.dims="X=float32,Y=float32,Z=float32"'];
    fprintf( fid, '%s\n', command4);
    %     pause
%      [status,cmdout] = system([command1 ';' command2 ';' command3 ';' command4])
end
fprintf( fid, '%s\n', command5);
fclose(fid);