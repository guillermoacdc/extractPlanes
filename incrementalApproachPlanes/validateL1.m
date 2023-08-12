clc
close all
clear 
% compara las longitudes L1 gt vs L1 reales de cada caja en la sesión.
% Asume que las sesiones no poseen apilamiento

% estimated ground normal
A=0.0048;
B=0.0261;
C=0.9996;
% sessionsID=[ 3	10	12	13	17	19	20	25 27	32	33	35 36 39 45	52	53	54];% 
sessionsID=[3 10 19 12 25 13 27 17 32 20 35 33 36 39 53 45 54 52];
% sessionsID=[ 32 ];

Ns=size(sessionsID,2);
% deviationHeightBySession=zeros(Ns,1);
meanDeviationL1BySession=zeros(Ns,1);
stdDeviationL1BySession=zeros(Ns,1);
frameID=1;
syntheticPlaneType=0;
accL1_e_perc=[];
figure,
for j=1:Ns
    sessionID=sessionsID(j);
    dataSetPath=computeMainPaths(sessionID);
    gtPlanes=loadInitialPose_v3(dataSetPath,sessionID,frameID,syntheticPlaneType);
    
    Nb=size(gtPlanes,2);%number of boxes
    L1_MoCap=zeros(Nb,1);
    boxID=zeros(Nb,1);
    xLocation=zeros(Nb,1);
    yLocation=zeros(Nb,1);
    for i=1:Nb
%         h_MoCap(i)=gtPlanes(i).tform(3,4);
        boxID(i)=gtPlanes(i).idBox;
        xLocation(i)=gtPlanes(i).tform(1,4);
        yLocation(i)=gtPlanes(i).tform(2,4);
        [p1, p2]=loadMarkerPosition(sessionID,10,boxID(i));%frameID 10
        L1_MoCap(i)=norm(p1-p2);
    end
    [~,L1_real]=loadBoxHeight(boxID,dataSetPath);
    % compute error
    L1_e=L1_real-L1_MoCap;%to identify negative values
    L1_e_abs=abs(L1_e);%to compute mean values
    L1_e_perc=100*abs(L1_e)./L1_real;%to compute relative values
    accL1_e_perc=[accL1_e_perc; L1_e_perc];

%     deviationHeightBySession(j)=sum(h_e_abs);
    meanDeviationL1BySession(j)=mean(L1_e_abs);
    stdDeviationL1BySession(j)=std(L1_e_abs);
    
        bubblechart(xLocation,yLocation,L1_e_perc) 
        hold on
        for k=1:Nb
%             if boxID(k)==1 | boxID(k)==2 | boxID(k)==3 | boxID(k)==4      
%             if boxID(k)==13
            if L1_e_perc(k)>9 
                text(xLocation(k), yLocation(k), num2str(boxID(k)));
                L1_ep=100*abs(L1_real(k)-L1_MoCap(k))/L1_MoCap(k);
%                 disp(['session: ' num2str(sessionID) '; boxID: ' num2str(boxID(k)) '; h_e: ' num2str(h_e(k)) '; h_ep: ' num2str(h_ep)])
                disp([num2str(sessionID) '          ' num2str(boxID(k)) '          ' num2str(L1_e(k)) '          ' num2str(L1_ep)])
            end
        end
        bubblelegend('L1_e (%)','Location','eastoutside')
%         title (['height error in boxes, session ' num2str(sessionID)])
        xlabel ('x (mm)')
        ylabel ('y (mm)')
    
end



    

% Plot 
figure,
hb = bar(meanDeviationL1BySession); % get the bar handles
hold on;
for k = 1:size(meanDeviationL1BySession,1)
    % get x positions per group
    xpos = hb(1).XData(k) + hb(1).XOffset;
    % draw errorbar
    errorbar(xpos, meanDeviationL1BySession(k), stdDeviationL1BySession(k), 'LineStyle', 'none', ... 
        'Color', 'k', 'LineWidth', 1);
end

% Set Axis properties
xticks(1:Ns)
xticklabels(sessionsID)
ylim([0 max(meanDeviationL1BySession)+8])
ylabel('mean deviation height')
xlabel('Session')
grid on

return
w = warning('query','last');
id=w.identifier;
warning('off',id)