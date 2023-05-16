clc 
close all
clear 

T1=eye(4);
T2=T1;
T2(1:3,1:3)=[0 -1 0; 0 0 1; -1 0 0];
T2(1:3,4)=[0 250 -150]';

T3=T1;
T3(1:3,1:3)=[0 0 1; 0 1 0; -1 0 0];
T3(1:3,4)=[200 0 -150]';

T4=T1;
T4(1:3,1:3)=[0 1 0; 0 0 -1; -1 0 0];
T4(1:3,4)=[0 -250 -150]';

T5=T1;
T5(1:3,1:3)=[0 0 -1; 0 -1 0; -1 0 0];
T5(1:3,4)=[-200 0 -150]';


figure,
dibujarsistemaref(T1, 'top', 150, 2 , 8 , 'b')
hold on
dibujarsistemaref(T2, 'front', 150, 2 , 8 , 'b')
dibujarsistemaref(T3, 'right', 150, 2 , 8 , 'b')
dibujarsistemaref(T4, 'back', 150, 2 , 8 , 'b')
dibujarsistemaref(T5, 'left', 150, 2 , 8 , 'b')
grid
xlabel 'x'
ylabel 'y'
zlabel 'z'