function sessionD = loadSessionDescriptor(dataSetPath,sessionID)
%LOADSESSIONDESCRIPTOR Loads data in session Descriptor as an structure
%with fields: boxesInSession, mocapRecordedFrames, factorLevels,
%poseByBoxAndFrame
%   Detailed explanation goes here
fileName='initialPose1.csv';
filePath=fullfile(dataSetPath,['corrida' num2str(sessionID)], 'mocap', fileName);

% reading the first line
fid = fopen(filePath);
fl=fgetl(fid); %reads line but does nothing with it
fclose(fid);
fl_num=str2num(fl);
sessionD.numberOfBoxes=fl_num(1);
sessionD.mocapRecordedFrames=fl_num(2);
sessionD.factorLevels=fl_num(3:end);
poses_t=readtable(filePath);
sessionD.poseByBoxAndFrame=poses_t;

end

