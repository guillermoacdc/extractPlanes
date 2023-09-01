function [pc_acc] = mergePC_cell(pc_cell,gridStep)
%MERGEPC_CELL Summary of this function goes here
%   Detailed explanation goes here
Npc=size(pc_cell,2);
for i=1:Npc
    pc=pc_cell{i};
    if i==1
        pc_acc=pc;
    else
        pc_acc=pcmerge(pc_acc,pc,gridStep);
    end
end
end

