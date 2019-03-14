clear all, close all, clc
[Cfh,Cft,Csa,Csk,Cth,Ctk,Ctrh,If,Is,It,Itr,Lf,Ls,Lt,Ltr,Wtr,Mf,Ms,Mt,Mtr]=BodyProperties(69,1.74);
H=[-1 -1 -1 -1 Ls/(Ls+Lt)
    0 1 0 0 0
    0 0 0 0 1
    1 1 1 0 0];
M=[[-Ls-Lt -Lt 0 0 0];H];

syms q1 q2 q3 q4 q5
syms dq1 dq2 dq3 dq4 dq5 t


q=[q1; q2; q3; q4; q5];
dq=[dq1; dq2; dq3; dq4; dq5];

vhip=0.9337;
alp=[0.0117 8.6591 0.1153 -2.1554 0.2419
-0.1739 13.6644 0.0397 3.3222 0.3332
-0.3439 10.5728 0.0464 -0.8606 0.6812
-0.0166 10.4416 -0.0033 3.2976 0.0729];
yHd=exp(-alp(:,4)*t).*(alp(:,1).*cos(alp(:,2)*t)+alp(:,3).*sin(alp(:,2)*t))+alp(:,5);

ep=0.1;
dt=0.01;
tf=0.57;
ti=0:dt:tf;

t=0;Q0=M^-1*eval([vhip*(0-tf/2);yHd]);syms t;
dyHd=diff(yHd,t);t=0;dyHd0=eval(dyHd);syms t;
DQ0=M^-1*[vhip;dyHd0];


t=tf/2+[-Ls-Lt -Lt 0 0 0]*q/vhip;
B=[zeros(1,4);diag([1 1 1 1])];
% y=simplify(H*q-eval(yHd));
% Lfy=jacobian(y,q)*dq;
% L2fy=jacobian(Lfy,[transpose(q) transpose(dq)])*[dq;-(Dq^-1)*phq];
% Lgfy=jacobian(Lfy,[transpose(dq)])*[(Dq^-1)*B];



%
y=simplify(H*q-eval(yHd));
Lfy=jacobian(y,q)*dq;
ya=simplify(H*q);
Lfya=jacobian(ya,q)*dq;
x=[transpose(q) transpose(dq)];
Lfyx=jacobian(Lfy,x);
Lfydq=jacobian(Lfy,dq);

Lfyax=jacobian(Lfya,x);
Lfyadq=jacobian(Lfya,dq);

matlabFunction(y,'File','eqy')
matlabFunction(Lfy,'File','eqLfy')
matlabFunction(Lfyx,'File','eqLfyx')
matlabFunction(Lfydq,'File','eqLfydq')
matlabFunction(ya,'File','eqya')
matlabFunction(Lfya,'File','eqLfya')
matlabFunction(Lfyax,'File','eqLfyax')
matlabFunction(Lfyadq,'File','eqLfyadq')
