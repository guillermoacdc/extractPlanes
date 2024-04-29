clc
close all
clear
% compute the performance of detection problem in the whole dataset

%% set parameters
% sessionsID=[ 3 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=3;

dataSetPath = computeReadPaths(1);
app='_v18';
evalPath = computeReadWritePaths(app);
Ns=length(sessionsID);
Npointsdp=40;
pk=1;
visiblePlanesByFrameFileName="visiblePlanesByFrame.json";
estimatedBoxesFileName=['estimatedBoxes_pk' num2str(pk) '.json'];
tao_vector=[50:50:100];
th_ADD_vector=[0.1:0.1:0.9];%consider using [0.17 , 0.34] 

Ntao=length(tao_vector);
NthADD=length(th_ADD_vector);

for itao=1:Ntao
    tao=tao_vector(itao);
    for ithADD=1:NthADD
        th_ADD=th_ADD_vector(ithADD);
        outputFileName=['assessmentBoxTracking_pk' num2str(pk) '_veADD.json',...
            '_tao' num2str(tao) '_thADD' num2str(th_ADD)];
        for i=1:Ns
            sessionID=sessionsID(i);
            evalPath=computeReadWritePaths(app);
            disp (['Assessing box tracking in session ' num2str(sessionID),...
                'with pk ' num2str(pk) ', ' ...
                'tao ' num2str(tao) ', ' ...
                'thADD ' num2str(th_ADD) ])
            assessment=computeTrackedBoxesMetricsBySession_veADD(estimatedBoxesFileName,...
                sessionID, tao, th_ADD, evalPath,visiblePlanesByFrameFileName, Npointsdp);
            assessment.Parameters.tao=tao;
            assessment.Parameters.th_eADD=th_ADD;
            % save result on disk
            mySaveStruct2JSONFile(assessment,outputFileName,evalPath,sessionID);
        end

    end
end




    

% removing warnings
w = warning('query','last');
id=w.identifier;
warning('off',id)
