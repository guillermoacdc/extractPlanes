function [TPhl2, TPm, FPhl2, FNm] = computeMetricsByFrame_v3(estimations_h, sessionID, ...
    frameID, gtPlanes, tao, theta, NpointsDiagPpal, planeType)
%COMPUTEMETRICSBYFRAME_V3 computes TPs, FPs, FNs by frame

if isempty(estimations_h)
    TPhl2=[];
    TPm=[];
    FPhl2=[];
    eADD_m=[];
else
    %   project estimations to qm coordinate system
    estimations_m=projectPoses_qh2qm(estimations_h.values, sessionID);
    %   compute eADD_m
    eADD_m=compute_eADD_v3(estimations_m, gtPlanes, tao, NpointsDiagPpal);
    %   convert eADD_m to TPs and FPs
    [TPhl2, TPm, FPhl2]=converteADD2TP_FP(estimations_m,...
        gtPlanes, eADD_m, theta);
end

%   compute FNs
FNm=computeFN(eADD_m, gtPlanes, sessionID, frameID, theta, planeType);
end

