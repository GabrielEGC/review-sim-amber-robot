clear all, close all, clc
cd('C:\Users\Gabriel Garcia\Documents\2018-II\Walk\Model');
addpath('C:\Users\Gabriel Garcia\Documents\2018-II\Walk\Functions');

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

dt=0.01;
tf=0.57;%0.57;
ti=0:dt:tf;

t=0;Q0=M^-1*eval([vhip*(0-tf/2);yHd]);syms t;
dyHd=diff(yHd,t);t=0;dyHd0=eval(dyHd);syms t;
DQ0=M^-1*[vhip;dyHd0];

clear QV DQV
Q=Q0*1.2;Q(1)=Q(1);%Initial position condition
QV(:,1)=Q; 
DQ=DQ0*1.2;%Initial velocitiy condition
DQV(:,1)=DQ;

%options = odeset();
options = odeset('RelTol',1e-8,'Events', @(T,Y) EventGuard0(T,Y,Ls,Lt,Wtr));

%options = odeset('RelTol',1e-8);
[ti,Y] = ode45(@AMBER,[0 4*tf],[Q;DQ],options);
QV=Y(:,1:5)';
DQV=Y(:,6:10)';

PlotTraj

%%
options2 = odeset('Events', @(T,Y) EventGuard(T,Y,Ls,Lt,Wtr));
%%Xn=[R zeros(5);zeros(5) R]*[];
disp('Performing a hundred of steps as iterations')
for iiter=1:100
Q0b=Y(end,1:5)';
DQ0b=Y(end,6:10)';

R = [1 1 1 1 -1; 0 0 0 0 1; 0 0 0 -1 0; 0 0 -1 0 0; 0 1 0 0 0];
Dq = eqDqsp(Q0b(2),Q0b(3),Q0b(4),Q0b(5));
Jn = eqJnsp(Ls,Lt,Q0b(1),Q0b(2),Q0b(3),Q0b(4),Q0b(5));
Q0a=R*Q0b;
DQ0a=R*(eye(5)-(Dq^-1)*Jn'*((Jn*(Dq^-1)*Jn')^-1)*Jn)*DQ0b;
[ti,Y] = ode45(@AMBER,[0 ti(end)*1.2],[Q0a;DQ0a],options2);

QV=Y(:,1:5)';
DQV=Y(:,6:10)';
disp(ti(end))
%PlotTraj %Uncomment this for visualization (and also reduce 100 iteration)
end
disp('After 100 steps: ')
PlotTraj
PlotTraj
PlotTraj
PlotTraj
%%
syms t
clear xph yH
xph(t)=vhip*(t-tf/2);
yH(t)=exp(-alp(:,4)*t).*(alp(:,1).*cos(alp(:,2)*t)+alp(:,3).*sin(alp(:,2)*t))+alp(:,5);

yHv=yH(ti);
yHm(1,:)=eval(xph(ti));
%
for i=1:size(yHv,1)
    yHm(i+1,:)=eval(yHv{i});
end
thpa=M^-1*yHm;
%%
% figure(5)
% plot(ti,QV); hold on, grid on
% legend('q1','q2','q3','q4','q5')
% plot(ti,thpa),grid on
% legend('sf','sk','sh','nsh','nsk');
% title('Angles')
tf=0.57;
t=tf/2+[-Ls-Lt -Lt 0 0 0]*q/vhip; % tau(theta)
yHde=eval(yHd);
q1=QV(1,:);q2=QV(2,:);q3=QV(3,:);q4=QV(4,:);q5=QV(5,:);
yV=H*QV-eval(yHde);
syms q1 q2 q3 q4 q5;
%
figure(6)
%plot(ti,M*thpa-M*QV),grid on
plot(ti,yV),grid on
title('Error')
%%
figure(7)
plot(ti,M*thpa-M*QV),grid on
title('Errors - Y-Y(t)')

%%
% figure(8)
% plot(ti,M*QV); hold on, grid on
% legend('q1','q2','q3','q4','q5')
% plot(ti,M*thpa),grid on
% legend('ph','ms','sk','nsk','tor')
% title('vars')
%%
figure(9)
thet=M*QV;
subplot(211)
plot(ti,thet(1,:),'x'),grid on,hold on
Ti = [ones(length(ti),1) ti];
b = Ti\thet(1,:)';
plot(ti,b(2)*ti+b(1))
legend('Hip position','Linear regression')
disp('Final vhip: ')
disp(b(2))
subplot(212)
plot(ti,b(2)*ti+b(1)-thet(1,:)')
legend('Error respect linear regression')