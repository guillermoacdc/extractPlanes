function [pos] = interpolateMarkersByChannel(markerStruct, IDs)
%INTERPOLATEMARKERSBYCHANNEL Summary of this function goes here
%   Detailed explanation goes here

nbMarkers=length(IDs);
nbFrames=length(markerStruct.time);
pos=zeros(3,nbMarkers,nbFrames);
display (['size of pose vector: ' num2str(size(pos))])
for(k=1:nbMarkers)
    if IDs(k)<10
        app='M00';
    else
        if IDs(k)<100
            app='M0';
        else
            app='M';
        end
    end

%	verificación de marcador sin valores validos
    eval(['TF = isnan(markerStruct.' app num2str(IDs(k)) ');']);
    sumTF=sum(TF);
    
    
    if sumTF(1)==nbFrames
            in=0;
            display (['marker ' app num2str(IDs(k)) ' without valid values'])
            continue
    else
        if sumTF(1)==0 %no requiere interpolación
            in=1;
            eval( ['x =markerStruct.' app num2str(IDs(k)) '(:,1);'] );
            eval( ['y =markerStruct.' app num2str(IDs(k)) '(:,2);'] );
            eval( ['z =markerStruct.' app num2str(IDs(k)) '(:,3);'] ); 
            pos(1:3,k,:)=[x y z]';
            
        else
%         interpolación sobre marcadores con valores válidos
            eval( ['[x in]=interpolateMocap(markerStruct.' app num2str(IDs(k)) '(:,1));'] );
            eval( ['y=interpolateMocap(markerStruct.' app num2str(IDs(k)) '(:,2));'] );
            eval( ['z=interpolateMocap(markerStruct.' app num2str(IDs(k)) '(:,3));'] );            
            pos(1:3,k,:)=[x y z]';
        end
	end
%     despliegue de primera muestra válida en cada marcador. Para
%     propóstios de verificación
    display(['marker ' num2str(IDs(k)) ' processed. k = ' num2str(k) '. First non-NaN Index= ' num2str(in)])
    display(['    time in ms: ' num2str(markerStruct.time(in)) '. Position in mm (x,y,z): ' ...
        num2str([x(in) y(in) z(in)]) ])
    
end

end

