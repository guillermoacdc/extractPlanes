function [boxLengths] = loadLengths_v2(rootPath,scene,pps)
%LOADLENGTHS Load lengths of boxes from a file called previousKnowledgeFile.txt
% The lengths are loaded in millimiters
% The output describes the box-length in the column sequence,
% IdBox,Heigth(mm),Width(mm),Depth(mm)
% The row sequence corresponds with the physical packing sequence (pps)

% 1. Load Physical Packing Sequence
% pps=getPPS(scene);
% 2. Load Length data
lengthInfo=getPreviousKnowledge(rootPath, pps);% IdBox,TypeBox,Heigth(cm),Width(cm),Depth(cm)
boxLengths=lengthInfo(:,[1 3 4 5]);
boxLengths(:,[2 3 4])=boxLengths(:,[2 3 4])*10; %length in mm

end

