function output = computeMaxNcomposedIDPlane(vectorPlane)
%COMPUTEMAXNCOMPOSEDIDPLANE Summary of this function goes here
%   Detailed explanation goes here

N=size(vectorPlane,2);

output=0;
for i=1:N
   if  vectorPlane(i).composed_idPlane>output
       output=vectorPlane(i).composed_idPlane;
   end
end

end

