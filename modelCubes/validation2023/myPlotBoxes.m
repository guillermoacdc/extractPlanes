function  myPlotBoxes(myPlanes, localBoxes)
%MYPLOTBOXES Summary of this function goes here
%   Detailed explanation goes here
NmbBoxes=size(localBoxes,2);

for i=1:NmbBoxes
    myPlotSingleBox_v2(myPlanes,localBoxes{i})%
%     uncomment the next line for structure without field cameraPose
%     myPlotSingleBox(myPlanes,localBoxes{i})%
end

view(2)
camup([0 1 0])
xlabel 'x (m)'
ylabel 'y (m)'
zlabel 'z (m)'

end

