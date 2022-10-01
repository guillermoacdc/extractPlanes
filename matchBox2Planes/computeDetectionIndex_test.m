clc
close all
clear all

rootPath="C:\lib\boxTrackinPCs\";
scene=6;
boxID=15;
planesDescriptors_gt=convertPK2PlaneObjects(rootPath,scene);
plane_gt=extractPlaneByBoxID(planesDescriptors_gt,boxID);

[detectionByFrameObj_h, detectionByFrameDescriptor]=computeDetectionIndex(plane_gt,scene,rootPath);

[er,et,el1,el2,p_detection]=computeErrorMetrics(detectionByFrameObj_h,detectionByFrameDescriptor,plane_gt,rootPath,scene);

et_mean=mean(et);
er_mean=mean(er);
et_std=std(et);
er_std=std(er);
el1_mean=mean(el1);
el1_std=std(el1);

% plot errors
indexes=find(detectionByFrameDescriptor(:,3));
frames=detectionByFrameDescriptor(indexes,1);
myxticksLabels=num2cell(frames);
myxticks=1:size(er,1);
figure,
subplot(411),...
    stem(er)
%     xlabel 'keyframes'
    ylabel 'e_r (deg)'
    xticks(myxticks)
    xticklabels(myxticksLabels')
    axis tight
    grid
    title (['Tracking and Length error in scene/box ' num2str(scene) '/' num2str(boxID) ' . Detection rate: ' num2str(p_detection) '%'])
subplot(412),...
    stem(et)
%     xlabel 'keyframes'
    ylabel 'e_t (mm)'    
    xticks(myxticks)
    xticklabels(myxticksLabels')
    axis tight
    grid

subplot(413),...
    stem(el1)
%     xlabel 'keyframes'
    ylabel 'e_{L1} (mm)'
    xticks(myxticks)
    xticklabels(myxticksLabels')
    axis tight
    grid
%     title (['Length error in scene/box ' num2str(scene) '/' num2str(boxID)])
subplot(414),...
    stem(el2)
    xlabel 'keyframes'
    ylabel 'e_{L2} (mm)'  
    xticks(myxticks)
    xticklabels(myxticksLabels')
    axis tight
    grid

    
