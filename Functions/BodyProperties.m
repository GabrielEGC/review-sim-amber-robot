function [Cfh,Cft,Csa,Csk,Cth,Ctk,Ctrh,If,Is,It,Itr,Lf,Ls,Lt,Ltr,Wtr,Mf,Ms,Mt,Mtr]=BodyProperties(MT,H)
% body properties
% MT = input('Please, enter the body mass in Kg: ');% kg
% H = input('Please, enter the body Heigh in m: '); %m 
% [Cfh,Cft,Csa,Csk,Cth,Ctk,Ctrh,If,Is,It,Itr,Lf,Ls,Lt,Ltr,Wtr,Mf,Ms,Mt,Mtr]=BodyProperties(MT,H)
% C= Center of mass 
if nargin==0
MT=65;
H=1.65;
end
dim=numel(num2str(ceil(H)));
if dim>1
    corrf=7;
else
    corrf=0.07;
end
%load parameters
Zatsiorsky_parameters;
%Human measures
%lenght
Lt = l_thigh*H;
Ls = l_shank*H;
Lf = l_foot*H-corrf;
Ltr = l_trunk*H;
Wtr = w_trunk*H;
%position of center mass
%Tight
Ctk=(1-c_thigh)*Lt;%from knee
Cth=c_thigh*Lt;%from hip joint
% Shank
Csa=(1-c_shank)*Ls;% from ankle
Csk=c_shank*Ls;%from knee
% foot
Cfh=c_foot*Lf; % from heel
Cft=(1-c_foot)*Lf; % from toe
% trunk
Ctrh=(1-c_trunk)*Lt;%from hip joint
%mass each link
Mtr=m_trunk*MT;
Mt=m_thigh*MT;
Ms=m_shank*MT;
Mf=m_foot*MT;

% Inertia Matrix
Itr=matrix_inertia(MT,H,'trunk');

It=matrix_inertia(MT,H,'thigh');

Is=matrix_inertia(MT,H,'shank');

If=matrix_inertia(MT,H,'foot');

