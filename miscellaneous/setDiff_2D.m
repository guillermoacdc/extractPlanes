function diff_out = setDiff_2D(vector2D,target2D)
%SETDIFF_V2 returns the elements of vector2D that are not present in
%the vector target2D. The size(vector2D)= (N,2)
%   Detailed explanation goes here

if isempty(vector2D)
    diff_out=[];
else
    if isempty(target2D)
        diff_out=vector2D;
    else
        Tvector2D=table(vector2D(:,1), vector2D(:,2));
        Ttarget2D=table(target2D(:,1), target2D(:,2));
        [~, b]=setdiff(Tvector2D,Ttarget2D);
        diff_out=vector2D(b,:);
    end
end

end

