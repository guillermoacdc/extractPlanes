clc
close all 
clear

%% parámetros
spatialSamplingRate=0.01;%10mm
L1=28;%28cm
L2=40;%40cm
alpha=40;%rotation angle for the top plane
M=L1;
N=L2;
%% crear banco de filtros
NmbFilters=9;%all in range 0 - pi
[filters angles]=createFilterBank_v2(NmbFilters,L1,L2, spatialSamplingRate);%data with size (M,N,NmbFilters)

%%
figure,
for i=1:9
subplot(3,3,i),...
    singleFilter=filters{i};
    imshow(singleFilter)
    xlabel (['angle = ' num2str(angles(i)) ' deg.']);
end

%% crear muestra de plano superior ocluido 
% crear datos 2D alineados con ejes x y
data=build2DallignedData_v2(M,N);% whole data
% crear versión ocluida
data2=build2DallignedData_v2(round(0.85*M),0.75*N);%
% data2=data2+[4 10];
[datax index]=setdiff(data,data2,'rows');
dataOccludedA=data(index,:);
% dataOccludedA=dataOccludedA+[M/4 N/4];

sdataOccludedA=uint8(zeros(M,N));
for i=1:size(dataOccludedA,1)
    sdataOccludedA(dataOccludedA(i,1)+1,dataOccludedA(i,2)+1)=180;
end
sdataOccludedR = imrotate(sdataOccludedA,alpha);
figure,
plot(dataOccludedA(:,1),dataOccludedA(:,2),'*','color', [.5 .5 .5])%gray color in vector 
title 'unstructured data'
figure,
imshow(sdataOccludedA)
title 'structured data'
figure,
imshow(sdataOccludedR)
title 'structured data rotated'

%% calcular correlación normalizada entre planos superior ocluido y cada miembro del banco de filtros
for i=1:9
figure,
    subplot(2,2,1),...
        imshow(sdataOccludedR)
    subplot(2,2,3),...
        singleFilter=filters{i};
        imshow(singleFilter)
        xlabel (['angle = ' num2str(angles(i)) ' deg.']);
    subplot(2,2,[2,4])
         c = normxcorr2(singleFilter,sdataOccludedR);
%         surf(c), shading flat
% Find the peak in cross-correlation.
        [ypeak,xpeak] = find(c==max(c(:)));
% Account for the padding that normxcorr2 adds.        
        yoffSet = ypeak-size(singleFilter,1);
        xoffSet = xpeak-size(singleFilter,2);
% Display the matched area by using the drawrectangle function 
        imshow(sdataOccludedR)
%         drawrectangle(gca,'Position',[xoffSet,yoffSet,size(singleFilter,2),size(singleFilter,1)], ...
%         'FaceAlpha',0);
        xlabel (['(xpeak, ypeak) = (' num2str(max(xpeak)) ', ' num2str(max(ypeak)) ' )' ])

end

% c = normxcorr2(theBullet,theMirror);

return



