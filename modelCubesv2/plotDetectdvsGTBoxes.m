function [outputArg1,outputArg2] = plotDetectdvsGTBoxes(myBoxes,...
    gtBoxes, sessionID)
%PLOTDETECTDVSGTBOXES Summary of this function goes here
%   Detailed explanation goes here

Ndb=length(myBoxes);
disp(['boxes detected: ' num2str(Ndb)])
% project position an rotation to qm
dataSetPath=computeReadPaths(sessionID);
Th2m=loadTh2m(dataSetPath,sessionID);
Theight=[0 1 0; 0 0 1; 1 0 0];
for i=1:Ndb
    myBoxes(i).tform=Th2m*myBoxes(i).tform;
    myBoxes(i).tform(1:3,1:3)=myBoxes(i).tform(1:3,1:3)*Theight;
end

% % % validation figures
% figure,
myPlotBoxes(gtBoxes , sessionID,'w')
hold on
myPlotBoxes(myBoxes, sessionID, 'y')
hold on
dibujarsistemaref(eye(4),'m',150,2,10,'w');


end

