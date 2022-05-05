function  myPlotBoxes(myPlanes, localBoxes)
%MYPLOTBOXES Summary of this function goes here
%   Detailed explanation goes here
NmbBoxes=size(localBoxes,2);

for i=1:NmbBoxes
    myPlotSingleBox(myPlanes,localBoxes{i})
end

view(2)
camup([0 1 0])
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'

end

