function PPS=loadPPS(rootPath,scene)
%LOADPPS Do not use this function, use getPPS
%   Detailed explanation goes here

    fileName=rootPath  + 'scene' + num2str(scene) + '\boxByFrame.txt';
    
    fid = fopen( fileName );
    cac = textscan( fid, '%d ', 'CollectOutput'  ...
                    ,   true, 'Delimiter', ' '  );
    [~] = fclose( fid );
    rig2M=cac{1}(2:end);
    N=length(rig2M);
    rig2M2=reshape(rig2M,3,N/3)';
    PPS=rig2M2(:,1);
end

