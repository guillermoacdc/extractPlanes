function [output] = extendPlaneID(input)
%EXTENDPLANEID Extiende un vector de una dimensión a un vector de dos
%dimensiones. En la segunda dimensión aparecen los número 1 a 4. Ejemplo
% Entrada: [10 20]
% Salida: [10 1; 10 2; 10 3; 10 4; 20 1; 20 2; 20 3; 20 4]
N=size(input,1);
output=zeros(4*N,2);
k=0;
for i=1:N
    for j=1:4
        kmod=mod(k,4)+1;
        output(k+1,:)=[input(i), kmod];
        k=k+1;
    end
end
end

