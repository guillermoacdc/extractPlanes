clc
close all
clear

mystep=0.1;
precision=0:mystep:1;
recall=0:mystep:1;
N=length(precision);

% compute f1-score
f1score=zeros(N,N);
for i=1:N
    for j=1:N
        p=precision(i);
        r=recall(j);
        f1score(i,j)=2*p*r/(p+r);
    end
end

% compute fmean
f1mean=zeros(N,N);
for i=1:N
    for j=1:N
        p=precision(i);
        r=recall(j);
        f1mean(i,j)=(p+r)/2;
    end
end

figure,
mesh(precision, recall, f1score)
xlabel 'precision'
ylabel 'recall'
% zlabel 'f1score'
grid on

hold on

mesh(precision, recall, f1mean)
xlabel 'precision'
ylabel 'recall'
% zlabel 'f1mean'
grid on