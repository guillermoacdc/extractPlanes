function toffset=computeToffsetForAScene(rootPath,scene,frame)


offset=0;
% load rig2mocap
[~, trm]=loadTm_c(rootPath,scene,frame,offset);
% load rig2hololens
[~, trh]=loadTh_c(rootPath,scene,frame);
% compute difference
tdiff=trm-trh;
% convert to seconds
toffset=tdiff*1e-7;
end