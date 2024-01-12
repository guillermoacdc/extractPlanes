% Assess estimated poses in local maps. For each session, consumes a file 
% with name localEstimations.json and generates two json files:
% localAssesment_planeType0.json, localAssessmentPlaneType1.json. 
% Each file has the next properties,
% Parameters
% framex
% |_TPhl2
% |_TPm
% |_FPhl2
% |_FNm
% |_Nnap
% Based on computeMetricsByFrame_v4.m
clc
close all
clear

%% set parameters
% sessionsID=[ 3 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=10;
% [dataSetPath,evalPath]=computeMainPaths(1);
dataSetPath = computeReadPaths(1);
app='_vdebug';
evalPath = computeReadWritePaths(app);
Ns=length(sessionsID);

% sessionID=10;
tao=50;
theta=0.5;
NpointsDiagPpal=30;
% planeTypes=[0 1];
planeTypes=1;
inputFileName='globalEstimations.json';
visiblePlanesFileName='globalVisiblePlanesByFrame.json';

for k=1:length(planeTypes)

    planeType=planeTypes(k);
    outputFileName=['globalAssessment_planeType' num2str(planeType) '.json'];
    %% iterative assesment by session
    for j=1:Ns
        sessionID=sessionsID(j);
        % load estimations for all frames
        estimatedPoses = loadEstimationsFile(inputFileName,sessionID, evalPath);
        keyFrames=estimatedPoses.keyFrames;
%         Nkf=length(keyFrames.mwdata);
        Nkf=length(keyFrames);
        %% iterative assessment by frame
        for i=1:Nkf
            frameID=keyFrames(i);
            if frameID==98
                disp('stop mark')
            end
            %load estimations in the current frame
            if planeType==0
                index=estimatedPoses.(['frame' num2str(frameID)]).values.xzIndex;
            else
                index1=estimatedPoses.(['frame' num2str(frameID)]).values.xyIndex;
                index2=estimatedPoses.(['frame' num2str(frameID)]).values.zyIndex;
                index=[index1; index2];
            end
            if isempty(index)
                globalPlanes=[];
            else
%                 tempData=estimatedPoses.(['frame' num2str(frameID)]).values.values.mwdata;
%                 globalPlanes.values=assembleGlobalPlanes(tempData,index);
                globalPlanes.values=estimatedPoses.(['frame' num2str(frameID)]).values.values(index);
                globalPlanes.Nnap=estimatedPoses.(['frame' num2str(frameID)]).Nnap;            
            end

            %% load gt planes for the current frame
%             gtPlanes=loadGTPlanes(sessionID,frameID);
            
            gtPlanes=loadGTPlanes_v2(sessionID,frameID,planeType, visiblePlanesFileName);

            %% compute metrics by frame
            myLegend=['Asessing frame s' num2str(sessionID)  '-' num2str(frameID) ' - index ' num2str(i) '/' num2str(Nkf)];
            disp(myLegend)
            [TPhl2, TPm, FPhl2, FNm] = computeTPFPFNByFrame_vplaneTracking(globalPlanes,...
                gtPlanes, tao, theta, sessionID, NpointsDiagPpal);

%             [TPhl2, TPm, FPhl2, FNm] = computeMetricsByFrame_v3(globalPlanes, sessionID, ...
%                 frameID, gtPlanes, tao, theta, NpointsDiagPpal, planeType);
            assessment.(['frame' num2str(frameID)]).TPhl2=TPhl2;
            assessment.(['frame' num2str(frameID)]).TPm=TPm;
            assessment.(['frame' num2str(frameID)]).FPhl2=FPhl2;
            assessment.(['frame' num2str(frameID)]).FNm=FNm;
            if isempty(globalPlanes)
                assessment.(['frame' num2str(frameID)]).Nnap=0;
            else
                assessment.(['frame' num2str(frameID)]).Nnap=globalPlanes.Nnap;
            end
            
        end
        % complement assessment fields
        assessment.Parameters.tao=tao;
        assessment.Parameters.theta=theta;
        assessment.Parameters.NpointsDiagPpal=NpointsDiagPpal;
        assessment.Parameters.planeType=planeType;
        
        % save result on disk
        mySaveStruct2JSONFile(assessment,outputFileName,evalPath,sessionID);
    
    end
end



return

% plot estimated and gt poses in qm--solve saving of pathPoints to enable
% this section
figure,
    plotEstimationsByFrame_v2(globalPlanes.values, planeType, sessionID, frameID);%script