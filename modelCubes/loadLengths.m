function [boxLengths] = loadLengths(rootPath,scene)
%LOADLENGTHS Load lengths of boxes from a file called previousKnowledgeFile.txt
% The lengths are loaded in millimiters
% The output describes the length of the top plane of the box in the
% sequences L1,L2,Height
% The relationship L1<L2 is keeped

%Notes. Think in change the format of input file to include descriptors,
%for example
% boxID classID depth   widht   length
% 5     2       20      50      35


% % Length information is in previousKnowledgeFile.txt
% fileName=rootPath  + 'scene' + num2str(scene) +'\previousKnowledgeFile.txt';
% lengthInfo=load(fileName); %length in cm
% boxLengths=lengthInfo(:,[1 4 5]);
% boxLengths(:,[2 3])=boxLengths(:,[2 3])*10; %length in mm

% Length information is in Aleatorizacion_v5.xlsx file, and requires the
% physical packin sequence of the scene
pps=getPPS(scene);
lengthInfo=getPreviousKnowledge(rootPath, pps);
boxLengths=lengthInfo(:,[1 4 5 3]);
boxLengths(:,[2 3 4])=boxLengths(:,[2 3 4])*10; %length in mm

% sort data to warrant length in sequence L1, L2
for i=1:size(boxLengths,1)
    if(boxLengths(i,2)>boxLengths(i,3))
%         swap
        aux=boxLengths(i,2);
        boxLengths(i,2)=boxLengths(i,3);
        boxLengths(i,3)=aux;
    end
end

end

