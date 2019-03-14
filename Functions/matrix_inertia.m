function I = matrix_inertia(MT,H,bodypart)
%%-------------------- Inertial Matriz Function----------------------------
% Matriz intertia is a function created to obtain the interial matriz of
% the body using the antropometrics parametres from the analysis of 
% zatsiorsky-Selayanov for male, adjusted by Leva P in "Leva P. Adjustments  
% to Zatsiorsky-Seluyanov's segment inertia parameters". 
%
% MT is the total mass of the body in Kg, H is the height of the body in 
% metres and Bodypart is the required part: head, trunk, upperarm,  
% forearm, thigh, shank,foot. Neck is not modeled
%  
% The plane perpendicular to axis x is Sagittal
% The plane perpendicular to axis y is Tranversal
% The plane perpendicular to axis Z is Frontal
% The resulting inertial Matrix is in Kg*m^2
%
% Copyright 2016
% UNI Biomechatronics Group - PERU
% Pietro Miranda

switch (bodypart)
    case 'head'
        m=0.0694;% mass percent
        h=0.1168; %lenght percent regarding to body height
        kff=0.312; %Frontal
        kss=0.376; %Transversal
        ktt=0.362; %Sagital

            
    case 'trunk'
        m=0.4346;
        h=0.3055;
        kff=0.372;
        kss=0.347;
        ktt=0.191; %longitudinal P leva
    
    case 'upperarm'
        m=0.0271;
        h=0.1618;
        kff=0.158;
        kss=0.269;
        ktt=0.285;
        
    case 'forearm'
        m=0.0162;
        h=0.1545;
        kff=0.121;
        kss=0.265;
        ktt=0.276;        
        
    case 'hand'
        m=0.0061;
        h=0.0495;
        kff=0.401;
        kss=0.513;
        ktt=0.628;
        
    case 'thigh'
        m=0.1416;
        h=0.2425;
        kff=0.329;
        kss=0.329;
        ktt=0.149; %longitudinal P leva
        
    case 'shank'
        m=0.0433;
        h=0.2493;
        kff=0.255;
        kss=0.249;
        ktt=0.103; %longitudinal P leva
        
    case 'foot'
        m=0.0137;
        h=0.1482;
        kff=0.124; %longitudinal P leva
        kss=0.245;
        ktt=0.257;
        
    otherwise
        msgbox('Incorrect body part');
        return
        
end
I = m*MT * (H*h)^2 * [kff^2 0 0; 0 kss^2 0; 0 0 ktt^2];

end 