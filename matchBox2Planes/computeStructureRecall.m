function [recall] = computeStructureRecall(sessionID,tao_v,theta_v, evalPath)
%UNTITLED read the mainOutput.csv file, interpretates and creates the
%structure recall
%   Detailed explanation goes here

N_tao=length(tao_v);
N_theta=length(theta_v);
for i=1:N_tao
    tao=tao_v(i);
    for j=1:N_theta
        theta=theta_v(j);
        fileName=['estimatedPoseA_session' num2str(sessionID) '_tao' num2str(tao),...
            '_theta' num2str(theta) 'aux2.csv'];
        T=readtable([evalPath 'scene' num2str(sessionID) '\' fileName]);%frameID,DP,MD,MP,SP
        T_a=table2array(T);
        Trecall=T_a(:,2)./(T_a(:,2)+T_a(:,4));
        recall.(['tao_' num2str(i)]).(['theta_' num2str(j)])=Trecall;

    end
end
recall.frames=T_a(:,1);
recall.tao_v=tao_v;
recall.theta_v=theta_v;
end

