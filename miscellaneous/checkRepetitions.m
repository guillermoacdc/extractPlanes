function outFlag = checkRepetitions(A)
%UNTITLED returns a value 1 if there exist repited values in A or if the
%elements in A have non adjacent values in their two last elements,
% i.e. [0 1 3] or [0 2 4]
%   Detailed explanation goes here
Aunique=unique(A);
repFlag= length(Aunique)==length(A);
repFlag=~repFlag;

Asorted=sort(A);
nonAdjacentFlag= (Asorted(2)==1 & Asorted(3)==3) | (Asorted(2)==2 & Asorted(3)==4);

outFlag= repFlag | nonAdjacentFlag;

end

