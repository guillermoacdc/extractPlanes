function estimatedPlanes_m=projectPoses_qh2qm(estimatedPlanes, sessionID)
%PROJECTPOSES_QH2QM SProjects estimated poses of accepted planes to qm 
% 
% 
%   Detailed explanation goes here
dataSetPath=computeMainPaths(sessionID);

estimatedPlanes_m=estimatedPlanes;
% Nep=size(estimatedPlanes,2);
Nep=length(estimatedPlanes);
% load Th2m
pathTh2m=fullfile(dataSetPath,['session' num2str(sessionID)],'analyzed');
fileName='Th2m.txt';
Th2m_array=load(fullfile(pathTh2m,fileName));
Th2m=assemblyTmatrix(Th2m_array);

% Projection by using the Th2m matrix
for i=1:Nep
    estimatedPlane=estimatedPlanes(i);
    switch estimatedPlane.type
        case 0    
            Theight=[0 1 0; 0 0 1; 1 0 0];
        case 1
            Theight=[0 -1 0; 1 0 0; 0 0 1];
%             if estimatedPlane.planeTilt==1
%                 %xy planes
%                 if estimatedPlane.L2toY==0
% %                     Theight=[0 -1 0; 1 0 0; 0 0 1];
%                     Theight=eye(3);
%                 else
%                     Theight=eye(3);
%                 end
%             else
%                 %zy planes--- se debe validar para L2ToY=1
%                 if estimatedPlane.L2toY==0
%                     Theight=eye(3);
% %                     Theight=[0 0 -1; 1 0 0; 0 -1 0];
%                 else
% %                     Theight=[0 0 -1; 0 1 0; 1 0 0];
%                     Theight=eye(3);
%                 end
%                 
%             end
            
    end
    Testimated=estimatedPlane.tform;%mt
    Testimated_m=Th2m*Testimated;
    %Requires an additional transformation to obtain the z-height in projected frame 
    Testimated_m(1:3,1:3)=Testimated_m(1:3,1:3)*Theight;
    estimatedPlanes_m(i).tform=Testimated_m;
end



end

