clc
close all
clear


rootPath="G:\Mi unidad\boxesDatabaseSample\";
% load scene ids
sceneIDs_t=readtable([rootPath + 'misc\Guillermo_ScenesWithLowOcclusion.txt']);
sceneIDs_a=sceneIDs_t.Var1;
sceneIDs = sceneIDs_a(~isnan(sceneIDs_a))';
sceneIDs = [5 sceneIDs];

for i=1:length(sceneIDs)
	scene=sceneIDs(i);
	[meanfsh maxfsh minfsh]=computeSamplingFreq(rootPath,scene);
	meanfshV(i)=meanfsh;
    maxfshV(i)=maxfsh;
    minfshV(i)=minfsh;
end

review=[sceneIDs' meanfshV' maxfshV' minfshV']