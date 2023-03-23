function [recallByFrame] = computeRecallByFrame(recall)
%COMPUTERECALLBYFRAME Summary of this function goes here
%   Detailed explanation goes here
Ntao=length(recall.tao_v);
Ntheta=length(recall.theta_v);

for i=1:Ntao
    tao=recall.tao_v(i);
%     recallByFrame.(['tao' num2str(i)]).values(j)=zeros(Nframes,Ntheta);
    for j=1:Ntheta
%         theta=recall.theta_v;
        recallByFrame.(['tao' num2str(i)]).values(:,j)=...
            recall.(['tao_' num2str(i)]).(['theta_' num2str(j)]);
    end
end
recallByFrame.frames=recall.frames;
end

