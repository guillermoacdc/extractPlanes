function [xyz] = crammerSolver3n(A,d)
%CRAMMERSOLVER3N Summary of this function goes here
%   Detailed explanation goes here
% based on example 9.8.4 in 
% https://math.libretexts.org/Bookshelves/Precalculus/Precalculus_(OpenStax)/09%3A_Systems_of_Equations_and_Inequalities/9.08%3A_Solving_Systems_with_Cramer's_Rule#:~:text=3.-,To%20solve%20a%20system%20of%20three%20equations%20in%20three%20variables,%2C%20z%3DDzD.
x=0;
y=0;
z=0;
D=det(A);
if D~=0
    Ax=[d A(:,2:3)];
    Ay=[A(:,1) d A(:,3)];
    Az=[A(:,1:2) d];
    Dx=det(Ax);
    Dy=det(Ay);
    Dz=det(Az);
    x=Dx/D;
    y=Dy/D;
    z=Dz/D;
else
    disp("error, the system has no solution. Determinant is zero")
end

xyz=[x y z]';

end

