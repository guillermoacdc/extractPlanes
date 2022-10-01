function R = myRotationSolver(Rch, Rcm) 

% computes the rotation matrix that allows to transform from h to m worlds
d1=Rcm(:,1);
d2=Rcm(:,2);
d3=Rcm(:,3);

c1=crammerSolver3n(Rch,d1);
c2=crammerSolver3n(Rch,d2);
c3=crammerSolver3n(Rch,d3);

R=[c1 c2 c3]';

end