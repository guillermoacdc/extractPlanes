function L1mm=roundCeil(L1mm,L1_pk)
%ROUNDCEIL Round L1mm to the nearest
% integer in L1_pk, greater than L1mm
%   Detailed explanation goes here

% compute distance wrt elements in L1_pk
d=L1_pk-L1mm;
for i=1:length(d)
    if d(i)<=0
        d(i)=realmax;
    end
end

[~,index]=min(d);
L1mm=L1_pk(index);
% penalize
end

