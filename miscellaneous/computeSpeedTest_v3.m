% script to compute speed by consuming the pose information from the file 
% sessionx/raw/HL2/Depth Long Throw_rig2world.txt

clc
close all
clear 

% sessionsID=[27];
sessionsID=[ 3	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
Ns=size(sessionsID,2);
speed=zeros(Ns,3);%mean value in column 1, std value in column 2, max value in column 3
% dataSetPath=computeMainPaths(1);
dataSetPath=computeReadPaths(1);
for j=1:Ns
    sessionID=sessionsID(j);
    % load time and position data
    HL2folderPath=fullfile(dataSetPath, ['session' num2str(sessionID)],'raw','HL2');
    [timeStampsHL2_ts_array, poseMatrix]=loadTimeStampsAndPoseHL2(HL2folderPath);% to convert timestamp to seconds multiply by 1e-7
    keyframes=loadKeyFrames(dataSetPath,sessionID);
    [speed_mean, speed_std, speedMax]=computeSpeed(timeStampsHL2_ts_array, poseMatrix, keyframes);
    
    speed(j,:)=[speed_mean, speed_std, speedMax];
end

    [sessionsID', speed]
    
return

function [speed_mean, speed_std, speed_max]=computeSpeed(timeStampsHL2_ts_array, poseMatrix, keyframes)
    % compute speed
    N=size(timeStampsHL2_ts_array,1);
    Nkf=size(keyframes,2);
    speed_array=zeros(N-1,1);
    for i=1:N-1
        deltaTime=(timeStampsHL2_ts_array(i+1)-timeStampsHL2_ts_array(i))*1e-7;%seconds
        T1=assemblyTmatrix(poseMatrix(i,:));
        T2=assemblyTmatrix(poseMatrix(i+1,:));
        modPosition=norm(T2(1:3,4)-T1(1:3,4));%mt
        speed_array(i)=modPosition/deltaTime;
    end
    speed_array=speed_array(keyframes);%
%     window=round(N/10);%window to remove samples at init and end of the session
%     speed_mean=mean(speed_array(window: end-window));
%     speed_std=std(speed_array(window: end-window));
    speed_mean=mean(speed_array);
    speed_std=std(speed_array);
    speed_max=max(speed_array);
% plot data    
xmin=0;
xmax=Nkf-1;

% figure,
%     plot(speed_array)
%     hold on
%     plot([xmin xmax],[speed_mean speed_mean],'--k')
%     xlabel ('time in seconds')
%     ylabel ('speed m/s')
%     axis tight
%     title (['operator speed mean/std:'  num2str(speed_mean) '/' num2str(speed_std) ])
%     grid    
end

function [timeStampsHL2_ts_array, pose_matrix]=loadTimeStampsAndPoseHL2(HL2folderPath)
%LOADTIMESTAMPSHL2 Summary of this function goes here
%   Detailed explanation goes here
    fileName='Depth Long Throw_rig2world.txt';
    dataPath=fullfile(HL2folderPath,fileName);
    data_table=readtable(dataPath);
    pose_matrix=table2array(data_table(:,2:end));
    timeStampsHL2_ts_array = table2array(data_table(:,1));
%     timeStampsHL2_ts_array = uint64(timeStampsHL2_ts_array);%relevant timestamps in ntfs
end

