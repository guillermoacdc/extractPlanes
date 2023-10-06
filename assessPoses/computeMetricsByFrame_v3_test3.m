clc
close all
clear

%% set parameters
sessionsID=[ 3 10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
[dataSetPath,evalPath]=computeMainPaths(1);
Ns=length(sessionsID);

% sessionID=10;
tao=50;
theta=0.5;
NpointsDiagPpal=30;
planeTypes=[0 1];

for k=1:length(planeTypes)

    planeType=planeTypes(k);
    outputFileName=['assessment_planeType' num2str(planeType) '.json'];
    inputFileName=['estimatedPoses_ia_planeType' num2str(planeType) '.json'];
    
    %% iterative assesment by session
    for j=1:Ns
        sessionID=sessionsID(j);
        % load estimations for all frames
        estimatedPoses = loadEstimationsFile(inputFileName,sessionID, evalPath);
        keyFrames=estimatedPoses.keyFrames;
        Nkf=length(keyFrames);
        %% iterative assessment by frame
        for i=1:Nkf
            frameID=keyFrames(i);
            if i==14
                display('stop mark')
            end
            %load estimations in the current frame
            globalPlanes=estimatedPoses.(['frame' num2str(frameID)]);
            %% load gt planes for the current frame
            gtPlanes=loadGTPlanes(sessionID,frameID);
            gtPlanesID=extractIDsFromVector(gtPlanes);
            Ngtplanes=size(gtPlanesID,1);
            idx=find(gtPlanesID(:,2)==1);
            if planeType==0 %top planes
            % delete lateral planes
                idxs=[1:Ngtplanes];
                idx=setdiff(idxs,idx);
                gtPlanes(idx)=[];
            else
            % delete top planes
                gtPlanes(idx)=[];
            end
            %% compute metrics by frame
            myLegend=['Asessing frame s' num2str(sessionID)  '-' num2str(frameID) ' - index ' num2str(i) '/' num2str(Nkf)];
            disp(myLegend)
            [TPhl2, TPm, FPhl2, FNm] = computeMetricsByFrame_v3(globalPlanes, sessionID, ...
                frameID, gtPlanes, tao, theta, NpointsDiagPpal, planeType);
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