function [side m] = classify2DpointwrtLine_v2(A,B,P)
%CLASSIFY2DPOINTWRTLINE This function classifies a 2D point P with respect to
%a line AB. The possible outputs are
% 0. For class 0 -- left in vertical partition and up in horizontal
% partition, and points above the line AB in partition with positive and
% negative slopes
% 1. For class 1 -- right in vertical partition and down in horizontal
% partition, and points under the line AB in partitio with positive and
% negative slopes


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


%% compute the class of P

if (m.defined)%defined m
    if (m.value==0)
        if(A(2)>P(2))
            side=1;%up side 
        else
            if (A(2)==P(2))
                side=2;
            else
                side=0;%down side
            end
        end
    else
        y=m.value*P(1)+b;
        if(y>P(2))
            side=1;%up side
%             side= (m.value>=0)*0 + (m.value<0)*1;            
        else
            if(y==P(2))
                side=2;
            else
                side=0;%down side
%                 side= (m.value>=0)*1 + (m.value<0)*0;
            end
        end

    end
else %not defined m
    if (A(1)>P(1))
        side=0;%left side 
    else
        if (A(1)==P(1))
            side=2;
        else
            side=1;%right side
        end
          
    end
end


end

