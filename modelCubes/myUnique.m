function [indexes ic] = myUnique(vector2d)
%MYUNIQUE Performs a unique operation, assuming that the pairs (a,b) is
%duplicated with (b,a). Returns indexes of unit elements

%   Detailed explanation goes here

% resort vector2d (a,b) with (a<b)
for i=1:length(vector2d)
    if (vector2d(i,1)>vector2d(i,2))
%     swap
        aux=vector2d(i,1);
        vector2d(i,1)=vector2d(i,2);
        vector2d(i,2)=aux;
    end
end
% apply unique to find the unique indexes
[~,indexes, ic]=unique(vector2d,'rows','stable');

end

