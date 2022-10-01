function [globalInit,globalEnd] = computeGlobal_Init_End(rootPath,scene)
%COMPUTEGLOBAL_INIT_END Summary of this function goes here
%   Detailed explanation goes here

availablets_h=loadAvailableTimeStampsH(rootPath,scene);
availablets_m=loadAvailableTimeStampsM(rootPath,scene);

initHL2=availablets_h(1);
endHL2=availablets_h(end);

initMocap=availablets_m(1);
endMocap=availablets_m(end);

if initHL2>initMocap
    globalInit=initHL2;
else
    globalInit=initMocap;    
end


if endHL2<endMocap
    globalEnd=endHL2;
else
    globalEnd=endMocap;    
end


end

