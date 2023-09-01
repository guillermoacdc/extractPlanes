function [frames, planeID, boxID] = getTargetFramesFromScene(scene)
%GETTARGETFRAMESFROMSCENE Retorna el frame, identificador de plano e
%identificador de caja usados como referencia para la evaluación de la pose
%estimada
planeID=0;
boxID=0;
switch(scene)
   case 1 
        frames=[7 8];
   case 2
%         frames=[30 31];
        frames=[80 : 81];
   case 3 
%         frames=[49 63];
        frames=[49 50];
        planeID=2;
        boxID=19;
   case 4 
%        frames=[2: 14];
        frames=[9 10];        
   case 5 
        frames=[24 25];
   case 6
      frames=[66 67];
   case 7
      frames=[17 18];      
   case 10 
%       frames=[16 17];
        frames=[24 25];
        planeID=2;
        boxID=17;        
   case 12 
        frames=[3 4]; 
        planeID=8;
        boxID=19;        
   case 13 
        frames=[9 10]; 
        planeID=9;
        boxID=16;        
   case 15
      frames=[103 104];
   case 17
      frames=[9 18];
        planeID=3;
        boxID=18;      
   case 18
      frames=[25 26];      
    case 19
        frames=[23 24];       
        planeID=5;
        boxID=17;
    case 20
        frames=[9 10];       
        planeID=6;
        boxID=18;        
   case 21
      frames=[31 32];  
   case 25
      frames=[27 28];  
        planeID=5;
        boxID=13;      
    case 27
        frames=[51 52];       
        planeID=2;
        boxID=20;        
    case 32 
      frames=[36 25];     
        planeID=6;
        boxID=16;      
    case 33 
      frames=[19 20];  
        planeID=3;
        boxID=18;      
    case 35 
      frames=[19 20];       
        planeID=16;
        boxID=19;      
   case 36 
      frames=[10 11];       
        planeID=2;
        boxID=18;      
    case 39 
      frames=[18 19];        
        planeID=2;
        boxID=17;      
    case 45 
      frames=[7 8];              
        planeID=2;
        boxID=19;      
   case 51 
      frames=[29 30];      
    case 52
        frames=[29 30];       
        planeID=5;
        boxID=17;
    case 53
        frames=[17 18];       
        planeID=2;
        boxID=17;        
    case 54 
      frames=[7 9];   
        planeID=4;
        boxID=17;
    otherwise
      frames=[7 8];
end

end