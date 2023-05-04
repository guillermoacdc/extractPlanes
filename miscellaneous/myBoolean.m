function [output] = myBoolean(input)
%MYBOOLEAN tf = myboolean(X) converts the numeric expression X into a 
% Boolean value. If the expression evaluates to zero, boolean returns logical 
% 0 (false). Otherwise, boolean returns logical 1 (true).

Nr=size(input,1);
Nc=size(input,2);
if Nr==0 | Nc==0
    output=[];
    return
end

for i=1:Nr
    for j=1:Nc
        output(i,j)=(input(i,j)==1);
    end
end

end

