function type = computeTypeOfTwin_v3(localPlane,globalPlane,...
    tao, theta, lengthBoundsTop, lengthBoundsP, th_cd)
%COMPUTETYPEOFTWIN Summary of this function goes here
%   Detailed explanation goes here
% type      Description
% 0         No twins
% 1         twins with high superposition (solve with selection)
% 4         twins with low superposition (solve through fusion)

	
    if(localPlane.type==0)
        maxTopSize=sqrt(lengthBoundsTop(1)^2+lengthBoundsTop(2)^2);%update 
    else
        maxTopSize=sqrt(lengthBoundsP(1)^2+lengthBoundsP(2)^2);%update 
    end
	
	eADD=compute_eADDTwins(localPlane,globalPlane,tao);
	if eADD<theta
		type=1;
%         type=4;
	else
		if isType4(localPlane,globalPlane,maxTopSize, th_cd)
			type=4;
		else 
			type=0;
		end
	end
end

