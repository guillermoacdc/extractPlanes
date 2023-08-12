function [boxHeight, boxL1] = loadBoxHeight(boxIDs,dataSetPath)
%LOADBOXHEIGHT Load the height of boxes in boxIDs vector
%   Return the data in mm
fileName='boxDescriptors.csv';
filePath=fullfile(dataSetPath, 'misc');
boxDescriptor_T=readtable(fullfile(filePath,fileName));
boxDescriptor_A = table2array(boxDescriptor_T);

% iterative seeking
Nb=size(boxIDs,1);
indexes=zeros(Nb,1);
for i =1: Nb
    indexes(i)=find(boxDescriptor_A(:,1)==boxIDs(i));
end

boxHeight =boxDescriptor_A(indexes,3)*10;% return data in mm
boxL1=boxDescriptor_A(indexes,5)*10;% return data in mm
end

