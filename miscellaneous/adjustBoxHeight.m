function [initPose_adjusted] = adjustBoxHeight(initPose, boxID, dataSetPath)
%UNTITLED Adjust box height
%   Esta función ajusta la altura de la caja en la matriz de poses
%   iniciales. Este ajuste es necesario puesto que se identifican
%   offsets relevante durante el análisis de datos. El offset se da entre
%   la h_mocap, h_real, siendo h_mocap la altura medida por el sistema
%   mocap y h_real la altura real de la caja
% Assumptions: la sesión que está siendo alterada NO tiene apilamiento.
% Cuando la sesión posee apilamiento, la estrategia aqui programada no
% funciona para cajas que reposan sobre otras cajas.


adjuxtedHeight=loadBoxHeight(boxID,dataSetPath);
initPose_adjusted=initPose;
initPose_adjusted(:,end)=adjuxtedHeight;
end

