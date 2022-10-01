%% validating translation of a point
% test point 1: origin of qh. Expected pm=T(1:3;4)
ph=[0 0 0 1]';%augmented vector
pm=T*ph;
pm(1:3)
% test point 2: origin of qm. Expected pm=[0 0 0];
Tinv=inv(T);
ph=Tinv(:,4);
pm=T*ph;
pm(1:3)

%% validating rotation of a vector
% test vector 1. unitary vector zh=[0 0 1]. Expected result> parallel
% vector to zh in the origin of qm
R=T(1:3,1:3);
zh=[0 0 1]';
zm=R*zh;
hold on
quiver3(0,0,0,zm(1),zm(2),zm(3))
