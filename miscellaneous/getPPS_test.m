clc
close all
clear 


sessionID=10;
dataSetPath=computeReadPaths(sessionID);
frameID=1;
pps = getPPS(dataSetPath,sessionID,frameID)
% Nb=size(pps,1);
% for i=1:Nb
%     X=sprintf('%d, ', pps(i));
% %     disp(X)
%     fprintf(X); 
% end
% disp(pps',',')