function output = computeMaxIDParticle(particlesVector)
%COMPUTEMAXIDPARTICLE Summary of this function goes here
%   Detailed explanation goes here
N=size(particlesVector,2);

output=0;
for i=1:N
   if  particlesVector(i).id>output
       output=particlesVector(i).id;
   end
end

end


