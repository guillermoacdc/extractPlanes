function initTimeM_ntfs=computeInitMocap_ntfs(rootPath,scene,offsetH,offsetMin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    append=computeAppend(scene);
    fileName=['corrida' num2str(scene) '-00' num2str(append)];
    jsonpath = fullfile(rootPath + 'corrida' + num2str(scene) + '\mocap\',[fileName '.rpd.json']);
    
    fid = fopen(jsonpath); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    val = jsondecode(str);
    
    % estimate init scanning time based on metadata
    % convert initTime to ntfs---   UTC-5h

    initTimeM_date=datetime(str2num(val.date(1:4)),...%year
        str2num(val.date(6:7)),str2num(val.date(9:10)),...%month, day
        str2num(val.time(1:2))+offsetH,str2num(val.time(4:5))+offsetMin,...%hour+5, min--convertion to UTC
        str2num(val.time(7:8)));%sec
    initTimeM_ntfs=convertTo(initTimeM_date,'ntfs');%132697151357259650
    % % % validation
    % initTimeM_str=datetime(uint64(initTimeM_ntfs),'ConvertFrom',...
    %     'ntfs','Format','yyyy-MM-dd HH:mm:ss.SSS');

end