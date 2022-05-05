function [indexes ic] = myUnique_v2(refVector)
%MYUNIQUE Performs a unique operation, assuming that the pairs (a,b,c,d) is
%duplicated with (a,d,c,b). Returns indexes of unit elements

%   Detailed explanation goes here

% resort refVector  with (a<=c) and (b<d)
for i=1:size(refVector,1)
    if (refVector(i,1)>refVector(i,3))
%     swap
        aux=refVector(i,1);
        refVector(i,1)=refVector(i,3);
        refVector(i,3)=aux;
    end

    if (refVector(i,2)>refVector(i,4))
%     swap
        aux=refVector(i,2);
        refVector(i,2)=refVector(i,4);
        refVector(i,4)=aux;
    end    
end
% apply unique to find the unique indexes
[~,indexes, ic]=unique(refVector,'rows','stable');

end

