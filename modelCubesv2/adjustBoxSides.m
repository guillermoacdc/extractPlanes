function sidesID = adjustBoxSides(myBox)
%ADJUSTBOXSIDES Computes complemetary sides from input
% assumption myBox.sidesID(1)=0;
% side complement
% 0     0
% 1     3   
% 2     4
% 3     1   
% 4     2

N=length(myBox.sidesID);
sidesID=zeros(N,1);
for i=2:N
    switch myBox.sidesID(i)
        case 1
            sidesID(i)=3;
        case 2
            sidesID(i)=4;
        case 3
            sidesID(i)=1;
        case 4
            sidesID(i)=2;
    end

end

end

