clc
close all
clear

rootPath="G:\Mi unidad\boxesDatabaseSample\";
scene=12;
commonMocapSample=10592;
commonHL2Sample=17;

% scene=5;
% commonMocapSample=24867;
% commonHL2Sample=18;

[initTimeM_date, initTimeM_ntfs,initTimeH_date, initTimeH_ntfs] = loadInitScanningTime(rootPath,scene);
offset_date=initTimeM_date-initTimeH_date;
offset_ntfs=double(initTimeM_ntfs)-double(initTimeH_ntfs);

display(['scene: ' num2str(scene) '; offset(s): ' num2str(seconds(offset_date)) '; offset(ntfs): '   num2str(offset_ntfs)])




[initTimeM_date, initTimeM_ntfs,initTimeH_date,...
    initTimeH_ntfs] = loadInitScanningTime_v2(rootPath,scene,commonHL2Sample,commonMocapSample);
offset_date=initTimeM_date-initTimeH_date;
offset_ntfs=double(initTimeM_ntfs)-double(initTimeH_ntfs);

display(['scene: ' num2str(scene) '; offset(s): ' num2str(seconds(offset_date)) '; offset(ntfs): '   num2str(offset_ntfs)])