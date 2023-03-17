function offset = computeOffsetByScene_resync(scene)
%COMPUTEOFFSETBYSCENE_RESYNC Summary of this function goes here
%   Detailed explanation goes here
	switch(scene)
	
	case 3
		offset=-4885416;	
	case 5
		offset=47552083;%47552083
	case 6
		offset=37677084;%39739591;
	case 21
		offset=80010417;
	case 51
		offset=85010417;%negative        

    otherwise
		offset=0;
		
    end

%     offset=uint64(offset);
end


