function [TPh, TPm, FPh, FNm] = convert_eM2TPFPFN(e_m, gtIDs,estimationsIDs)
%CONVERT_EM2TPFPFN Converts the matrix of error to vectors of TP, FP, FN.
%Each vector contains the id of estimations or gt in the dataset
% input: e_m matrix with size Ne, Ngt and boolean values

% compute indexes
[TPindexm, TPindexh, FNindexm]=seekIndexWith0InColumns(e_m);
FPindex=seekIndexWitlAll1InRows(e_m);
% convert indexes to identifiers
TPm=gtIDs(TPindexm);
TPh=estimationsIDs(TPindexh,:);
FPh=estimationsIDs(FPindex,:);
FNm=gtIDs(FNindexm,:);
end

