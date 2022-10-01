function lengthKnowledge = getPreviousKnowledge(rootPath, ...
    physicalPackingSequence)
%GETPREVIOUSKNOWLEDGE Loads previous knowledge from a physical packing
%sequence

filename=rootPath+'misc\'+'Aleatorizacionv5.xlsx';
previousKnowledge_t = readtable(filename,'Sheet','boxesDescriptors');
% previousKnowledge = xlsread(filename,3);

previousKnowledge_t =previousKnowledge_t([2:32],[1:5]);
previousKnowledge = table2array(previousKnowledge_t);

lengthKnowledge=zeros(length(physicalPackingSequence),5);
for i=1:length(physicalPackingSequence)
    boxId=physicalPackingSequence(i);
    index=find(previousKnowledge(:,1)==boxId);
    lengthKnowledge(i,:)=previousKnowledge(index,:);
end

end

