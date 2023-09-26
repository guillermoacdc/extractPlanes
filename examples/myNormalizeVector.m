function Y= myNormalizeVector(X)
%MYNORMALIZEVECTOR Scales the values of a vector to fit in the range -1 1

m=2/(max(X)-min(X));
b=1-2*min(X)/(max(X)-min(X));

Y=m*X+b;

end

