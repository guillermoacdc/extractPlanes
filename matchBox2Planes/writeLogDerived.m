function writeLogDerived(evalPath, scene, frame,derivedMetrics,NestimatedPlanes)

DP=sum(derivedMetrics(:,2));
MD=sum(derivedMetrics(:,3));
MP=sum(derivedMetrics(:,4));
SP=NestimatedPlanes-DP;
fileName='derivedMetrics.txt';
fid=fopen([evalPath '\scene'  num2str(scene) '\' fileName],'a');
fprintf(fid, '%d %d %d %d %d\n', frame, DP, MD, MP, SP);%
fclose(fid);
end