function eRotationMatrix = computeRotationErrorMatrix(myBoxes,...
    annotatedBoxes)
%COMPUTEROTATIONERRORMATRIX Computes th error rotaion matrix
%   Detailed explanation goes here
th_rotation=15;
Neb=length(myBoxes);%number of estimated boxes
Nab=length(annotatedBoxes);%number of annotated boxes
eRotationMatrix=ones(Neb,Nab);
for i=1:Nab
    annotatedBox=annotatedBoxes(i);
    annotatedRotation=annotatedBox.tform(1:3,1:3);
    for j=1:Neb
        myBox=myBoxes(j);
        estimatedRotation=myBox.tform(1:3,1:3);
%         compute rotation error
        eRotation=acos((trace(estimatedRotation'*annotatedRotation)-1)/2)*180/pi;
        eRotation=real(eRotation);%indagate what about the imaginary part
        if eRotation>180-th_rotation
            eRotation=180-eRotation;
        end
        eRotationMatrix(j,i)=eRotation;
    end
end
end

