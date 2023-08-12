clc
close all
clear 
% compara las alturas gt vs las altura reales de cada caja en la sesión.
% Asume que las sesiones no poseen apilamiento


% sessionsID=[ 3	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
% sessionsID=[ 32 ];

Ns=size(sessionsID,2);
deviationHeightBySession=zeros(Ns,1);
meanDeviationHeightBySession=zeros(Ns,1);
stdDeviationHeightBySession=zeros(Ns,1);
frameID=1;
syntheticPlaneType=0;

for j=1:Ns
    sessionID=sessionsID(j);
    dataSetPath=computeMainPaths(sessionID);
    gtPlanes=loadInitialPose_v3(dataSetPath,sessionID,frameID,syntheticPlaneType);
    
    N=size(gtPlanes,2);%number of boxes
    h_gt=zeros(N,1);
    boxID=zeros(N,1);
    xLocation=zeros(N,1);
    yLocation=zeros(N,1);
    for i=1:N
        h_gt(i)=gtPlanes(i).tform(3,4);
        boxID(i)=gtPlanes(i).idBox;
        xLocation(i)=gtPlanes(i).tform(1,4);
        yLocation(i)=gtPlanes(i).tform(2,4);
    end
    h_real=loadBoxHeight(boxID,dataSetPath);
    % compute error
    h_e=abs(h_gt-h_real);
    deviationHeightBySession(j)=sum(h_e);
    meanDeviationHeightBySession(j)=mean(h_e);
    stdDeviationHeightBySession(j)=std(h_e);
    figure,
        bubblechart(xLocation,yLocation,h_e) 
        hold on
        for k=1:N
            text(xLocation(k), yLocation(k), [num2str(boxID(k)) '-' num2str(h_e(k),3)]);
        end
        bubblelegend('h_e (mm)','Location','eastoutside')
        title (['height error in boxes, session ' num2str(sessionID)])
end



    

% Plot 
figure,
hb = bar(meanDeviationHeightBySession); % get the bar handles
hold on;
for k = 1:size(meanDeviationHeightBySession,1)
    % get x positions per group
    xpos = hb(1).XData(k) + hb(1).XOffset;
    % draw errorbar
    errorbar(xpos, meanDeviationHeightBySession(k), stdDeviationHeightBySession(k), 'LineStyle', 'none', ... 
        'Color', 'k', 'LineWidth', 1);
end

% Set Axis properties
xticks(1:Ns)
xticklabels(sessionsID)
ylim([0 60])
ylabel('mean deviation height')
xlabel('Session')
grid on

return
w = warning('query','last');
id=w.identifier;
warning('off',id)