%% cleaning
clear all, close all, clc, format short
% preparing workspace
cd('C:\Users\Gabriel Garcia\Documents\2018-II\Walk\Model');
addpath('C:\Users\Gabriel Garcia\Documents\2018-II\Walk\Functions');
%% Considerations
% Arms and hands arent considered.

%% Initial Data
n=5;
saveeq=1;
% initiaizing variables
syms q1 q2 q3 q4 q5
syms dq1 dq2 dq3 dq4 dq5
syms ddq1 ddq2 ddq3 ddq4 ddq5 
%Human measures
syms Lt Ls Wtr 
syms Ctk ...from knee
     Cth... from hip joint
     Csa... from ankle
     Csk... from knee
     Ctrh % from hip joint
syms Mt Mtr Ms
syms ga
syms Itrx Itrxy Itrxz Itryx Itry Itryz Itrzx Itrzy Itrz
syms Itx Itxy Itxz Ityx Ity Ityz Itzx Itzy Itz
syms Isx Isxy Isxz Isyx Isy Isyz Iszx Iszy Isz


q=[q1; q2; q3; q4; q5];
dq=[dq1; dq2; dq3; dq4; dq5];
ddq=[ddq1; ddq2; ddq3; ddq4; ddq5];
g=[0,-ga,0];%m/s^2
%mass
M=[Ms, Mt, Mtr, Mt, Ms];
% Inertia Matrix
Itr=[Itrx, Itrxy, Itrxz; Itryx, Itry, Itryz; Itrzx, Itrzy, Itrz];
It=[Itx, Itxy, Itxz; Ityx, Ity, Ityz; Itzx, Itzy, Itz];
Is=[Isx, Isxy, Isxz; Isyx, Isy, Isyz; Iszx, Iszy, Isz];
I(:,:,1)=Is;I(:,:,2)=It;I(:,:,3)=Itr;
I(:,:,4)=It;I(:,:,5)=Is;
%% Denavit Hartemberg 
% Denavit Hartemberg Parametres
%   d         theta   r           Alpha   Link      
%----------------------------------------- 
% DH=[0         q1+pi/2 Ls     pi   ;    %1-2
%     0         q2      Lt     pi   ;    %2-3
%     Wtr       q3      0      pi   ;    %3-4
%     0         pi+q4   Lt     pi   ;    %4-5
%     0         q5      Ls     pi   ];   %5-6   PAPER
DH=[0         pi/2+q1   Ls     0   ;    %1-2   thsf=q1
    0         q2        Lt     0   ;    %2-3        
    Wtr       q3        0      0   ;    %3-4         
    0         q4        -Lt    0   ;    %4-5        
    0         -q5       -Ls    pi];   %5-6          
% DH matrix
for i=1:n
    Ai(:,:,i)=simplify(DH_matrix(DH(i,:)));
end
% Total Transformation Matrix
Ti(:,:,1)=Ai(:,:,1);
for i=2:n
    Ti(:,:,i)=simplify(Ti(:,:,i-1)*Ai(:,:,i));
end
%% Kinematics
%kinematics of each joint
%position
for i=1:n
    P(:,:,i)=simplify(Ti(1:3,4,i)); % Taking end point positions
    R(:,:,i)=simplify(Ti(1:3,1:3,i));
end
% velocities
for i=1:n
    J(:,:,i)=(jacobian(P(:,:,i),[q1 q2 q3 q4 q5])); %calculating jacobian
    Vel(:,:,i)=(J(:,:,i)*dq); %Velocities    
end
% Accelerations
for k=1:n
    for j=1:3
        for i=1:length(q)
            dJ(j,i,k)=(jacobian(J(j,i,k),[q1 q2 q3 q4 q5])*dq);           
        end
    end
end
for i=1:n
    Accel(:,:,i)=(dJ(:,:,i)*dq+J(:,:,i)*ddq);
end
%% Dinamics 
% kinetic energy
% Ek=1/2*Sum(V'*m*V+w'*D*w)
% Center of mass of each link since ref k
dC(:,:,1)=[-Csk;0;0];
dC(:,:,2)=[-Cth;0;0];
dC(:,:,3)=[Ctrh;0;-Wtr/2];
dC(:,:,4)=[Ctk;0;0];
dC(:,:,5)=[Csa;0;0];
% Center of mass of each link since Ref 0
for i=1:n
    C(:,:,i)=simplify(P(:,:,i)+R(:,:,i)*dC(:,:,i));
end
%Veloicities of center of mass
for i=1:n
    V(:,:,i)=(jacobian(C(:,:,i),[q1 q2 q3 q4 q5])*dq);
end

% Calculating the Matrix D for inertias.
for i=1:n
    D(:,:,i)= simplify(R(:,:,i)*I(:,:,i)*transpose(R(:,:,i)));
end

% angular velocities 
ze=zeros(3,1);
W(:,:,1)=  [1.*R(1:3,3,1),ze,ze,ze,ze]*dq;
W(:,:,2)=  [1.*R(1:3,3,1),1.*R(1:3,3,2),ze,ze,ze]*dq;
W(:,:,3)=  [1.*R(1:3,3,1),1.*R(1:3,3,2),1.*R(1:3,3,3),ze,ze]*dq;
W(:,:,4)=  [1.*R(1:3,3,1),1.*R(1:3,3,2),1.*R(1:3,3,3),1.*R(1:3,3,4),ze]*dq;
W(:,:,5)=       [1.*R(1:3,3,1),1.*R(1:3,3,2),1.*R(1:3,3,3),1.*R(1:3,3,4),1.*R(1:3,3,5)]*dq;
% kinetic Energy
%%
for i=1:n
Ek(i)=(1/2*(transpose(V(:,:,i))*M(i)*V(:,:,i)+transpose(W(:,:,i))*D(:,:,i)*W(:,:,i)));
end
T=(sum(Ek));
% Potencial Energy
for i=1:n
    Ep(i)=-(M(i)*g*C(:,:,i));
end
U=(sum(Ep));
% Lagrangeano
L=(T-U);
[Cfh,Cft,Csa,Csk,Cth,Ctk,Ctrh,If,Is,It,Itr,Lf,Ls,Lt,Ltr,Wtr,Mf,Ms,Mt,Mtr]=BodyProperties(69,1.74);
Itrz=Itr(3,3);Itz=It(3,3);Isz=Is(3,3);
gra=9.81; ga=9.81
L=simplify(eval(L));
%% Lagrange Formulation
for i=1:n
%dLq=(diff(L,q(i)));
%ddLdqdt=(jacobian(diff(L,dq(i)),[transpose(q) transpose(dq)])*[dq;ddq]);tsp(i,1)=(ddLdqdt-dLq); % torques
phq(i,1)=(jacobian(diff(L,dq(i)),transpose(q))*dq)-diff(L,q(i));
end
Dq=simplify(jacobian(transpose(jacobian(L,dq(1:n))),[transpose(dq(1:n))]));
%tsp(i,1)=(ddLdqdt-dLq); % torques
Jn=J(1:2,:,n);
%PImp=simplify((eye(n)-(Dq^-1)*Jn'*((Jn*(Dq^-1)*Jn')^-1)*Jn));
%% Saving variables as functions
if saveeq==1;
    matlabFunction(phq,'File','eqphqsp');
    matlabFunction(C,'File','eqCsp')
    matlabFunction(P,'File','eqPsp')
    matlabFunction(R,'File','eqRsp')
    matlabFunction(Dq,'File','eqDqsp')
    matlabFunction(Jn,'File','eqJnsp')
end
