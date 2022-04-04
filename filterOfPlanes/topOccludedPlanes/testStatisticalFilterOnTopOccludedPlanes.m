clc
close all 
clear

%% parámetros
spatialSamplingRate=0.01;%10mm
L1=0.25;%25cm
L2=0.4;%40cm
L1p=0.8;
L2p=0.7;
alpha=40;%rotation angle for the top plane
M=100*L1+1;
N=100*L2+1;


%% crear muestra de plano superior ocluido 
sdataOccludedR=createOccludedPlaneSample(0.8*L1,0.8*L2,L1p,L2p, alpha, spatialSamplingRate);

figure,
imshow(sdataOccludedR)
title 'structured data rotated'
return
%% calcular correlación normalizada entre planos superior ocluido y cada miembro del banco de filtros
refAngles=[0:10:180];
for j=1:length(refAngles)
    sdataOccludedR=createOccludedPlaneSample(L1,L2,L1p,L2p, refAngles(j), spatialSamplingRate);
    for i=1:size(angles,2)
        c=[];
        scene=sdataOccludedR;
        singleFilter=filters{i};
        offsetrows=size(scene,1)-size(singleFilter,1);
        offsetcols=size(scene,2)-size(singleFilter,2);
        if offsetrows<0
    %         resize scene adding offset rows
            scene=[scene; zeros(-offsetrows,size(scene,2))];  
        end
        if offsetcols<0
    %         resize scene adding offset columns
            scene=[scene, zeros(size(scene,1), -offsetcols)];  
        end
        c = normxcorr2(singleFilter,scene);%(template, scene)
        % Find the peak in cross-correlation.
        [xpeak,ypeak] = find(c==max(c(:)));
        Cmax(i)=c(xpeak(1),ypeak(1));
    % figure,
    % imshow(scene)
    end
[~,index]=max(Cmax);
estimatedAngle(j)=angles(index);

end
% [refAngles' estimatedAngle']
figure,
bar(refAngles,abs(refAngles-estimatedAngle))
title (['error of estimated angle assuming reduction of 20% in sample. (p_{L_1}, p_{L_2}): (' num2str(L1p) ', ' num2str(L2p) ')' ])
grid on



