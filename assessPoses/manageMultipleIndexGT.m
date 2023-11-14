function indexGT = manageMultipleIndexGT(indexGT,rowi)
%MANAGEMULTIPLEINDEXGT Summary of this function goes here
%   Detailed explanation goes here

Nigt=length(indexGT);
values=ones(Nigt,1);
for i=1:Nigt
    values(i)=rowi(indexGT(i));
end
[~,idx]=min(values);
indexGT=indexGT(idx);

end

