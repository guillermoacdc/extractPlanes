function lengthKnowledge = getPreviousKnowledge(rootPath, ...
    physicalPackingSequence)
%GETPREVIOUSKNOWLEDGE Loads length previous knowledge in a physical packing
%sequence. The output has size N,5 where N is the number of boxes and the
%columns are in the sequence>
% IdBox,TypeBox,Heigth(cm),Width(cm),Depth(cm)

% filename=rootPath+'misc\'+'Aleatorizacionv5.xlsx';
% previousKnowledge_t = readtable(filename,'Sheet','boxesDescriptors');%Id,Type,Heigth(cm),Width(cm),Depth(cm)

% filename=rootPath+'misc/'+'boxDescriptors.csv';
fileName='boxDescriptors.csv';
filePath=fullfile(rootPath,'misc');
previousKnowledge_t = readtable(fullfile(filePath,fileName));
% previousKnowledge_t =previousKnowledge_t([2:32],[1:5]);
previousKnowledge = table2array(previousKnowledge_t(:,[1:5]));

lengthKnowledge=zeros(length(physicalPackingSequence),5);
for i=1:length(physicalPackingSequence)
    boxId=physicalPackingSequence(i);
    index=find(previousKnowledge(:,1)==boxId);
    lengthKnowledge(i,:)=previousKnowledge(index,:);
end

end

