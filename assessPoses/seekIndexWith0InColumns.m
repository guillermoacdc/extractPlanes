function [TPindexm, TPindexh, FNm] = seekIndexWith0InColumns(em)
%SEEKINDEXWITH0INCOLUMNS Seeks for TP and FN in the matrix em
TPindexm=[];
TPindexh=[];
FNm=[];
Ngt=size(em,2);
for j=1:Ngt
    targetColumn=em(:,j);
    ANDColumn=myANDvector(targetColumn);
    if ANDColumn
        FNm=[FNm, j];
    else
        i=find(targetColumn==0);
        TPindexm=[TPindexm, j];
        TPindexh=[TPindexh, i(1)];%el índice 1 resuelve casos de multiples estimaciones que coinciden con un gt. Debe ser revisado
    end
end
end

