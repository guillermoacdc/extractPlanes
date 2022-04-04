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
%% rotar datos completos y ocluidos
% theta=135+80*pi/180;
theta_deg=30;
theta=theta_deg*pi/180;
% [data gc] = my2DRot(data,theta);
[dataOccluded gc_o] = my2DRot(dataOccludedA,theta);

% Find AB points
[A B]=findPartitionLine(dataOccluded,0);

figure, 
subplot(121)
    plot(dataOccludedA(:,1),dataOccludedA(:,2),'*','color', [.5 .5 .5])%gray color in vector
%     hold on
%     plot([A(1) B(1)],[A(2) B(2)],'b-')
    grid on
%     title 'occluded data wout rotation'
subplot(122),...
    plot(dataOccluded(:,1),dataOccluded(:,2),'*','color', [.5 .5 .5])%gray color in vector
    hold on
    plot([A(1) B(1)],[A(2) B(2)],'b-')
    grid on
    title (['occluded data rotated by: ' num2str(theta_deg) ' degrees'])

    
% group data in two categories: dataS1, dataS2
k1=1;
k2=1;
for (i=1:size(dataOccluded,1))
    testResult=classify2DpointwrtLine(A,B,dataOccluded(i,:));
    if (testResult==0)
        dataS1(k1,:)=dataOccluded(i,:);
        k1=k1+1;
    else
        dataS2(k2,:)=dataOccluded(i,:);
        k2=k2+1;
    end
end

% apply L1L2 measure over dataS1 and dataS2. 
% figure,
% subplot(121),...
    [S1L1_p1 S1L1_p2 S1L2_p1 S1L2_p2]=findPartitionLine(dataS1,0);
%     title('segmento 1') 
% subplot(122),...
    [S2L1_p1 S2L1_p2 S2L2_p1 S2L2_p2]=findPartitionLine(dataS2,0);
%     title('segmento 2') 

S1_L1=norm(S1L1_p1-S1L1_p2);
S1_L2=norm(S1L2_p1-S1L2_p2);
S2_L1=norm(S2L1_p1-S2L1_p2);
S2_L2=norm(S2L2_p1-S2L2_p2);

L1_estimated=S1_L2;
L2_estimated=S2_L2+S1_L1;

% compute x
s1_l1=S1L1_p2-S1L1_p1;
% k=norm(S2L2_p2-S2L2_p1)/norm(S1L1_p2-S1L1_p1);
k=L2_estimated/S1_L1;
s1_l1Amp=k*s1_l1;
x=S1L1_p1+s1_l1Amp;


figure, 
    plot(dataS1(:,1),dataS1(:,2),'*','color', [.5 .5 .5])%gray color in vector
    hold on
    plot(dataS2(:,1),dataS2(:,2),'*','color', [.8 .5 .3])%x color in vector
    % plot partition line
    plot([A(1) B(1)],[A(2) B(2)],'b-')
    % plot extensions
    plot(x(1),x(2), 'bo')
    plot(S1L1_p1(1),S1L1_p1(2), 'bo')
    grid on
    title 'occluded data'

return
S1_L1=norm(S1L1_p1-S1L1_p2);
S1_L2=norm(S1L2_p1-S1L2_p2);
S2_L1=norm(S2L1_p1-S2L1_p2);
S2_L2=norm(S2L2_p1-S2L2_p2);

L1_estimated=S2_L2;
L2_estimated=S1_L2+S2_L1;


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
plot(dataS1(:,1),dataS1(:,2),'*','color', [.5 .5 .5])%gray color in vector
hold on
plot(dataS2(:,1),dataS2(:,2),'*','color', [.8 .5 .3])%x color in vector
% plot partition line
plot([A(1) B(1)],[A(2) B(2)],'b-')
% plot extensions
plot(s2_l1Amplified(1),s2_l1Amplified(2), 'bo')
plot(S2L1_p1(1),S2L1_p1(2), 'bo')
grid on
title 'occluded data'

return
