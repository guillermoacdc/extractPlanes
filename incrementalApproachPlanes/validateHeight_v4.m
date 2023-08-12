clc
close all
clear 
% compara las alturas gt vs las altura reales de cada caja en la sesión.
% Asume que las sesiones no poseen apilamiento

% estimated ground normal
A=0.0048;
B=0.0261;
C=0.9996;
% sessionsID=[ 3	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
% sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
sessionsID=[ 3 ];

Ns=size(sessionsID,2);
% deviationHeightBySession=zeros(Ns,1);
meanDeviationHeightBySession=zeros(Ns,1);
stdDeviationHeightBySession=zeros(Ns,1);
frameID=1;
syntheticPlaneType=0;
acch_e_perc=[];
figure,
for j=1:Ns
    sessionID=sessionsID(j);
    dataSetPath=computeMainPaths(sessionID);
    gtPlanes=loadInitialPose_v3(dataSetPath,sessionID,frameID,syntheticPlaneType);
    
    N=size(gtPlanes,2);%number of boxes
    h_MoCap=zeros(N,1);
    boxID=zeros(N,1);
    xLocation=zeros(N,1);
    yLocation=zeros(N,1);
    for i=1:N
%         h_MoCap(i)=gtPlanes(i).tform(3,4);
        h_MoCap(i)=[A B C]*gtPlanes(i).tform(1:3,4);
        boxID(i)=gtPlanes(i).idBox;
        xLocation(i)=gtPlanes(i).tform(1,4);
        yLocation(i)=gtPlanes(i).tform(2,4);
    end
    h_real=loadBoxHeight(boxID,dataSetPath);
    % compute error
    h_e=h_real-h_MoCap;%to identify negative values
    h_e_abs=abs(h_e);%to compute mean values
    h_e_perc=100*abs(h_e)./h_real;%to compute relative values
    acch_e_perc=[acch_e_perc; h_e_perc];

%     deviationHeightBySession(j)=sum(h_e_abs);
    meanDeviationHeightBySession(j)=mean(h_e_abs);
    stdDeviationHeightBySession(j)=std(h_e_abs);
    
        bubblechart(xLocation,yLocation,h_e_abs) 
        hold on
        for k=1:N
%             if boxID(k)==1 | boxID(k)==2 | boxID(k)==3 | boxID(k)==4      
%             if boxID(k)==13
            if h_e_perc(k)>9 
                text(xLocation(k), yLocation(k), num2str(boxID(k)));
                h_ep=100*abs(h_MoCap(k)-h_real(k))/h_MoCap(k);
%                 disp(['session: ' num2str(sessionID) '; boxID: ' num2str(boxID(k)) '; h_e: ' num2str(h_e(k)) '; h_ep: ' num2str(h_ep)])
                disp([num2str(sessionID) '          ' num2str(boxID(k)) '          ' num2str(h_e(k)) '          ' num2str(h_ep)])
            end
        end
        bubblelegend('h_e (mm)','Location','eastoutside')
%         title (['height error in boxes, session ' num2str(sessionID)])
        xlabel ('x (mm)')
        ylabel ('y (mm)')
    
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
ylim([0 max(meanDeviationHeightBySession)+8])
ylabel('mean deviation height')
xlabel('Session')
grid on

return
w = warning('query','last');
id=w.identifier;
warning('off',id)