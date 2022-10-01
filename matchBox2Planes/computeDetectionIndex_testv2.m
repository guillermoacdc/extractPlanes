clc
close all
clear all

rootPath="C:\lib\boxTrackinPCs\";
scene=6;
boxID=12;
planeType=1;
% define planeType str
switch planeType
    case 0
        planeType_str='xy';
    case 1
        planeType_str='xz';
    case 2
        planeType_str='yz';        
end
fileName=['log_planeType' planeType_str '_box' num2str(boxID) '.txt'];
figureName=['trackError_planeType' planeType_str '_box' num2str(boxID) '.png'];
fid = fopen( [rootPath + ['scene' num2str(scene) '\logTrackPlanes\' fileName]], 'wt' );

% compute maximal search frame by box ID
bxByFrame=computeMaximalSearchFrame(rootPath,scene,boxID);%box id initFrame LastFrame
mxSearchFrame=bxByFrame(3);
planesDescriptors_gt=convertPK2PlaneObjects_v2(rootPath,scene,planeType);
plane_gt=extractPlaneByBoxID(planesDescriptors_gt,boxID);

[detectionByFrameObj_h, detectionByFrameDescriptor]=computeDetectionIndex_v3(plane_gt,scene,rootPath,planeType,mxSearchFrame);

if ~isempty(detectionByFrameObj_h)
    [er,et,el1,el2,p_detection]=computeErrorMetrics(detectionByFrameObj_h,detectionByFrameDescriptor,plane_gt,rootPath,scene);
    
    et_mean=mean(et);
    er_mean=mean(real(er));
    if er_mean>170
        er=real(er)-180;
        er_mean=real(mean(er));
    end
    
    et_std=std(et);
    er_std=std(er);
    el1_mean=mean(el1);
    el1_std=std(el1);
    el2_mean=mean(el2);
    el2_std=std(el2);
    
    distanceToCamera=detectionByFrameDescriptor(:,4)*1000;%mm
    [myindex]=find(distanceToCamera);
    distanceToCamera=distanceToCamera(myindex);
    distanceToCamera_mean=mean(distanceToCamera);

    % plot errors
    indexes=find(detectionByFrameDescriptor(:,3));
    frames=detectionByFrameDescriptor(indexes,1);
    N=length(frames);
    myxticksLabels=num2cell(frames);
    myxticks=1:size(er,1);

    
    %   compute number of points by keyFrameVector
    for i=1:N
        inliersByFrame(i)=detectionByFrameObj_h(i).numberInliers;
    end
    samplingRes=inliersByFrame/(plane_gt.L1*plane_gt.L2);
    samplingRes_mean=mean(samplingRes);
    samplingRes_min=min(samplingRes);
    samplingRes_max=max(samplingRes);


    figure,
    subplot(611),...
        stem(er)
        hold on
        plot([0 N],[er_mean er_mean],'--');%plot mean value
        ylabel (['e_r ' num2str(er_mean,'%4.1f')])
        xticks(myxticks)
        xticklabels(myxticksLabels')
        axis tight
        grid
        title (['Tracking  and Length error (mm/deg) in scene/box ',...
            num2str(scene) '/' num2str(boxID) ' . Detection rate: ' num2str(p_detection,'%4.1f') '%. Planes type ' planeType_str])
    subplot(612),...
        stem(et)
        hold on
        plot([0 N],[et_mean et_mean],'--');%plot mean value    
        ylabel (['e_t ' num2str(et_mean,'%4.1f')])   
        xticks(myxticks)
        xticklabels(myxticksLabels')
        axis tight
        grid
    
    subplot(613),...
        stem(el1)
        hold on
        plot([0 N],[el1_mean el1_mean],'--');%plot mean value
        ylabel (['e_{L1} ' num2str(el1_mean,'%4.1f')])
        xticks(myxticks)
        xticklabels(myxticksLabels')
        axis tight
        grid
    %     title (['Length error in scene/box ' num2str(scene) '/' num2str(boxID)])
    subplot(614),...
        stem(el2)
        hold on
        plot([0 N],[el2_mean el2_mean],'--');%plot mean value
        ylabel (['e_{L2} ' num2str(el2_mean,'%4.1f')])  
        xticks(myxticks)
        xticklabels(myxticksLabels')
        axis tight
        grid
    subplot(615),...
        stem(inliersByFrame)
        hold on
        plot([0 N],[mean(inliersByFrame) mean(inliersByFrame)],'--');%plot mean value
        ylabel (['inliers ' num2str(mean(inliersByFrame),'%4.1f')])  
        xticks(myxticks)
        xticklabels(myxticksLabels')
        axis tight
        grid
    subplot(616),...
        stem(distanceToCamera)
        hold on
        plot([0 N],[distanceToCamera_mean distanceToCamera_mean],'--');%plot mean value
        ylabel (['d_c ' num2str(distanceToCamera_mean,'%4.1f')]) 
        xlabel (['keyframes. Expected at ' num2str(bxByFrame(2)) ' to ' num2str(bxByFrame(3))])
        xticks(myxticks)
        xticklabels(myxticksLabels')
        axis tight
        grid

% save figure in disk
saveas(gcf,[rootPath + ['scene' num2str(scene) '\logTrackPlanes\' figureName]])

        % final report
        L1=plane_gt.L1;
        L2=plane_gt.L2;
        el1_mean_rel=el1_mean*100/L1;
        el2_mean_rel=el2_mean*100/L2;
        
        fprintf(fid,['Scene ' num2str(scene) ', planes type ' planeType_str ', box ' num2str(boxID) '\n']);
        fprintf(fid,'Tracking Error\n' );
            fprintf(fid,[9 'rotation error (deg) mean/std= ' num2str(er_mean,2) '/' num2str(er_std,2) '\n']);
            fprintf(fid,[9 'translation error (mm) mean/std= ' num2str(et_mean,2) '/' num2str(et_std,2) '\n']);
        fprintf(fid,'Length estimation error\n');
            fprintf(fid,[9 'length L1(' num2str(L1) 'mm) error mean/std=' num2str(el1_mean,2) '/' num2str(el1_std,2) '\n']);
            fprintf(fid,[9 'length L2(' num2str(L2) 'mm) error mean/std=' num2str(el2_mean,2) '/' num2str(el2_std,2) '\n']);
            
            fprintf(fid,[9 'length L1(' num2str(L1) 'mm) relative error mean=' num2str(el1_mean_rel,'%4.1f') '%% \n' ]);
            fprintf(fid,[9 'length L2(' num2str(L2) 'mm) relative error mean=' num2str(el2_mean_rel,'%4.1f') '%% \n']);
        fprintf(fid,['Sampling resolution (inliers/mm2) mean/max/min=' num2str(samplingRes_mean,2) '/' num2str(samplingRes_max,2) '/' num2str(samplingRes_min,2) '\n']);
else

    fprintf (fid, ['The box ' num2str(boxID) ' was not detected in any of the keyframes \n']);
    disp( ['The box ' num2str(boxID) ' was not detected in any of the keyframes \n']);
end
fclose(fid);
