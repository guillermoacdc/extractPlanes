function [Th2m, fitIndex] = loadTh2m(dataSetPath,sessionID)
%LOADTH2M Loads Th2m from dataSetPath. The length is in mm
%   Detailed explanation goes here


pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
fitIndex=Th2m_array(end);
Th2m=assemblyTmatrix(Th2m_array);


end

