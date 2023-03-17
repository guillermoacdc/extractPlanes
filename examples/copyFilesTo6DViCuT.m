clc
close all
clear
sessions=[1	2	3	4	5	6	7	10	12	13	15	16	17	18	19	20	21	25	27	32	33	35	36	39	45	52	53	54];
N=length(sessions);

% create json files from MoCap

fid = fopen( 'createMoCapDescriptors_json.txt', 'wt' );%object to write a txt file 
sourcePath='/home/gacamacho/Downloads/jsonMocapFiles-20230317T154509Z-001/jsonMocapFiles/session';% 1/.';
destinationPath='~/Documents/6DViCuT_v1/session';% 1/raw/MoCap/';
for i=1:N
	session=sessions(i);
	command_str=['cp -R ' sourcePath num2str(session) '/. ' destinationPath num2str(session) '/raw/MoCap/'];
    fprintf(fid,'%s \n',command_str);
end
fclose(fid);

return

% create folder raw/Kinect
fid = fopen( 'createRawKinect.txt', 'wt' );%object to write a txt file 
for i=1:N
	session=sessions(i);
	command_str=['cp -R /media/gacamacho/dctGuillermo/boxesDatabase_2021/capturasKinect/Corrida\ ' num2str(session) '/.  ~/Documents/6DViCuT_v1/session' num2str(session) '/raw/Kinect/']
    fprintf(fid,'%s \n',command_str);
end
fclose(fid);
return
% create folder raw/HL2
fid = fopen( 'createRawHL2.txt', 'wt' );%object to write a txt file 
for i=1:N
	session=sessions(i);
	command_str=['cp -R /media/gacamacho/dctGuillermo/boxesDatabase_2021/HL2/Uniandes/corrida' num2str(session) '/.  ~/Documents/6DViCuT_v1/session' num2str(session) '/raw/HL2/']
    fprintf(fid,'%s \n',command_str);
end
fclose(fid);