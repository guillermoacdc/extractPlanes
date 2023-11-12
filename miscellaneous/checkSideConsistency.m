function outFlag = checkSideConsistency(A)
%CHECKSIDECONSISTENCY checks consistency in the vector of sides A
% returns a value 0 if there exist repited values in A or if the
%elements in A have non adjacent values in their two last elements,
% i.e. [0 1 3] or [0 2 4]

Aunique=unique(A);
nonRepFlag= length(Aunique)==length(A);

Asorted=sort(A);
adjacentFlag= (Asorted(2)==1 & Asorted(3)==2) | (Asorted(2)==2 & Asorted(3)==3) | (Asorted(2)==3 & Asorted(3)==4) | (Asorted(2)==1 & Asorted(3)==4);

outFlag= nonRepFlag & adjacentFlag;

end

