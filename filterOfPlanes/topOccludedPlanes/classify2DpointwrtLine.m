function [side m] = classify2DpointwrtLine(A,B,P)
%CLASSIFY2DPOINTWRTLINE This function classifies a 2D point P with respect to
%a line AB. The possible outputs are
% 0. For side 0 -- left in vertical partition and up in horizontal
% partition
% 1. For side 1 -- right in vertical partition and down in horizontal
% partition
% 2. For point P in the line AB
%   Detailed explanation goes here

%% validation of input data
if (A(1)==B(1) & A(2)==B(2))
    disp("error in slope computation at classify2DpointwrtLine.m. The points A, B must be different")
    return 
end

%% compute parameters of the line AB


if (A(1)==B(1))
    m.defined=false;% case of m==infinite
else
    m.defined=true;
    if(A(2)==B(2))% case of m==0
        m.value=0;
    else
        m.value=(B(2)-A(2))/(B(1)-A(1));
        b=A(2)-m.value*A(1);
    end
end


%% compute the side of P

if (m.defined)%defined m
    if (m.value==0)
        if(A(2)>P(2))
            side=0;%down side 
        else
            if (A(2)==P(2))
                side=2;
            else
                side=1;%up side
            end
        end
    else
        y=m.value*P(1)+b;
        if(y>P(2))
            side=0;%down side
%             side= (m.value>=0)*0 + (m.value<0)*1;            
        else
            if(y==P(2))
                side=2;
            else
                side=1;%up side
%                 side= (m.value>=0)*1 + (m.value<0)*0;
            end
        end

    end
else %not defined m
    if (A(1)>P(1))
        side=1;%left side -- invert with 0 during validation
    else
        if (A(1)==P(1))
            side=2;
        else
            side=0;%right side
        end
          
    end
end


end

