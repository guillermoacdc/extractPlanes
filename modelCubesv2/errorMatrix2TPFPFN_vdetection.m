function [TPh, TPm, FPh, FNm] = errorMatrix2TPFPFN_vdetection(eDetection_matrix, ...
    th_d,gtIDs,estimationsIDs)
%ERRORMATRIX2TPFPFN_VDETECTION converts the error matrix eDetection_matrix
%into metrics for TP, FP, FN
%   Detailed explanation goes here
    ebool=eDetection_matrix>th_d;% a detection is considered incorrect if ed>th_d
    % compute indexes
    [TPindexm, TPindexh, FNindexm]=seekIndexWith0InColumns(ebool);
    FPindex=seekIndexWitlAll1InRows(eDetection_matrix);
    % convert indexes to identifiers
    TPm=gtIDs(TPindexm);
    TPh=estimationsIDs(TPindexh,:);
    FPh=estimationsIDs(FPindex,:);
    FNm=gtIDs(FNindexm,:);
end

