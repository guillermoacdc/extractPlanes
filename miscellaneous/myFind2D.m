function idx = myFind2D(target,list)
%MYFIND2D performs a find operation in a two dimensional list
%   idx is the row where the target was found
idx=[];

if isempty(list)
    return
end


row=find(list(:,1)==target(1));

if ~isempty(row)
    N=size(row,1);
    for i=1:N
        if list(row(i),1)==target(1) & list(row(i),2)==target(2)
            idx=row(i);
        end
    end
    
end


end

