function FPindex=seekIndexWitlAll1InRows(e_m)
%SEEKINDEXWITLALL1INROWS Seeks FP in matrix e_m
Ne=size(e_m,1);
FPindex=[];
for i=1:Ne 
    targetRow=e_m(i,:);
    ANDrow=myANDvector(targetRow);
    if ANDrow
        FPindex=[FPindex, i];
    end
end
end

