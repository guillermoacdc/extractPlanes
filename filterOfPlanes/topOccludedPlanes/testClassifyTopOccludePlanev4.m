clc
close all 
clear

%% crear datos 2D alineados con ejes x y
spatialSamplingRate=0.01;%10mm
L1=0.25;%25cm
L2=0.4;%40cm
% spatialSamplingRate=1;%1mm
% L1=10;%25cm
% L2=7;%40cm

% whole data
data=build2DallignedData(L1,L2, spatialSamplingRate);
   
%% crear versión ocluida

% tipo L
data2=build2DallignedData(0.85*L1,0.75*L2, spatialSamplingRate);
% data2=data2+[4 10];

[datax index]=setdiff(data,data2,'rows');
dataOccludedA=data(index,:);

% figure,
%     plot(dataOccludedA(:,1),dataOccludedA(:,2),'*','color', [.5 .5 .5])%gray color in vector
%     grid on
 
%% rotar datos ocluidos
for theta_deg=10:10:80
    dataOccluded=[];
    dataS1=[];
    dataS2=[];

    theta=theta_deg*pi/180;
    [dataOccluded gc_o] = my2DRot(dataOccludedA,theta);

    
    % Find AB points
    [A B]=findPartitionLine(dataOccluded,0);

    % group data in two categories: dataS1, dataS2
    k1=1;
    k2=1;
    for i=1:size(dataOccluded,1)
         [testResult slope]=classify2DpointwrtLine_v2(A,B,dataOccluded(i,:));
%         if(i==221)
%             disp(["slope is " num2str(slope.value)])
%         end

        if (testResult==0)
            dataS1(k1,:)=dataOccluded(i,:);
            k1=k1+1;
        else
            dataS2(k2,:)=dataOccluded(i,:);
            k2=k2+1;
        end
    end

% figure,
% subplot(2,2,[1 3]),...
%        plot(dataOccluded(:,1),dataOccluded(:,2),'*','color', [.5 .5 .5])%gray color in vector 
% subplot(222),...
%         plot(dataS1(:,1),dataS1(:,2),'*','color', [.5 .5 .5])%gray color in vector
% subplot(224),...
%         plot(dataS2(:,1),dataS2(:,2),'*','color', [.5 .5 .5])%gray color in vector        
%   
% end
% return

    
    % apply L1L2 measure over dataS1 and dataS2. 
    
    [S1L1_p1 S1L1_p2 S1L2_p1 S1L2_p2]=findPartitionLine(dataS1,0);
    [S2L1_p1 S2L1_p2 S2L2_p1 S2L2_p2]=findPartitionLine(dataS2,0);
    
    S1_L1=norm(S1L1_p1-S1L1_p2);
    S1_L2=norm(S1L2_p1-S1L2_p2);
    S2_L1=norm(S2L1_p1-S2L1_p2);
    S2_L2=norm(S2L2_p1-S2L2_p2);
    
    L1_estimated=S1_L2;
    L2_estimated=S2_L2+S1_L1;
    
    % compute x
    s1_l1=S1L1_p2-S1L1_p1;
    
    k=L2_estimated/S1_L1;
    s1_l1Amp=k*s1_l1;
    x=S1L1_p1+s1_l1Amp;
    
    S1_L1=norm(S1L1_p1-S1L1_p2);
    S1_L2=norm(S1L2_p1-S1L2_p2);
    S2_L1=norm(S2L1_p1-S2L1_p2);
    S2_L2=norm(S2L2_p1-S2L2_p2);
    
    A1=S1_L1*S1_L2;
    A2=S2_L1*S2_L2;
    
    if A2>A1
        L1_estimated=S2_L2;
        L2_estimated=S1_L2+S2_L1;
    else
        L1_estimated=S1_L2+S2_L2;
        L2_estimated=S1_L1;
    end
    
    
    %% amplify the lengths en each segment
    %segment 2 (S2)
    
    % compute vectors s1_l2 s2_l1
    s1_l2=S1L2_p2-S1L2_p1;
    s2_l1=S2L1_p2-S2L1_p1;
    % compute amplification factor k
    k=L1_estimated/norm(s2_l1);
    % amplify s2_l1 (multiply and then translate its origin)
    s2_l1Amplified=k*s2_l1;
    s2_l1Amplified=s2_l1Amplified+S2L1_p1;
    
    figure, 
    
    subplot(221),...
        plot(dataS1(:,1),dataS1(:,2),'*','color', [.5 .5 .5])%gray color in vector
        hold on  
        plot(S1L1_p1(1),S1L1_p1(2),'ro')
        text(S1L1_p1(1),S1L1_p1(2),'S1_{L1_{p1}}','Color','k');

        plot(S1L1_p2(1),S1L1_p2(2),'ro')
        text(S1L1_p2(1),S1L1_p2(2),'S1_{L1_{p2}}','Color','k');
        
        plot(S1L2_p1(1),S1L2_p1(2),'ro')
        text(S1L2_p1(1),S1L2_p1(2),'S1_{L2_{p1}}','Color','k');
        
        plot(S1L2_p2(1),S1L2_p2(2),'ro')
        text(S1L2_p2(1),S1L2_p2(2),'S1_{L2_{p2}}','Color','k');
%         points
    subplot(223),...
        plot(dataS2(:,1),dataS2(:,2),'*','color', [.5 .5 .5])%gray color in vector
        hold on  
        plot(S2L1_p1(1),S2L1_p1(2),'ro')
        text(S2L1_p1(1),S2L1_p1(2),'S2_{L1_{p1}}','Color','k');

        plot(S2L1_p2(1),S2L1_p2(2),'ro')
        text(S2L1_p2(1),S2L1_p2(2),'S2_{L1_{p2}}','Color','k');
        
        plot(S2L2_p1(1),S2L2_p1(2),'ro')
        text(S2L2_p1(1),S2L2_p1(2),'S2_{L2_{p1}}','Color','k');
        
        plot(S2L2_p2(1),S2L2_p2(2),'ro')
        text(S2L2_p2(1),S2L2_p2(2),'S2_{L2_{p2}}','Color','k'); 
%         points
    subplot(2,2,[2 4]),...
        plot(dataS1(:,1),dataS1(:,2),'*','color', [.8 .5 .3])%gray color in vector
        hold on
        plot(dataS2(:,1),dataS2(:,2),'*','color', [.5 .5 .5])%x color in vector
        % plot partition line
        plot([A(1) B(1)],[A(2) B(2)],'b-')
        text(A(1), A(2),'A','Color','k'); 
        text(B(1), B(2),'B','Color','k'); 

        % plot extensions
        plot(s2_l1Amplified(1),s2_l1Amplified(2), 'bo')
        plot(S2L1_p1(1),S2L1_p1(2), 'bo')
        grid on
        title (['Rotated by: ' num2str(theta_deg) ' degrees. (L1,L2)=(' num2str(L1_estimated) ',' num2str(L2_estimated) ')'])
end

