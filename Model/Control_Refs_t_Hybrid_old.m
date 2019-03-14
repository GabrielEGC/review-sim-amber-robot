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
tf=0.57;
ti=0:dt:tf;

t=0;Q0=M^-1*eval([vhip*(0-tf/2);yHd]);syms t;
dyHd=diff(yHd,t);t=0;dyHd0=eval(dyHd);syms t;
DQ0=M^-1*[vhip;dyHd0];

clear QV DQV
Q=Q0*1;Q(1)=Q(1);QV(:,1)=Q;
DQ=DQ0*1;DQV(:,1)=DQ;

options = odeset('RelTol',1e-8);
%options = odeset();
[ti,Y] = ode45(@AMBER,[0 4*tf],[Q;DQ],options);
QV=Y(:,1:5)';
DQV=Y(:,6:10)';
PlotTraj

%%Xn=[R zeros(5);zeros(5) R]*[];
%%
for iiter=1:100
% q1=QV(1,:);q2=QV(2,:);q3=QV(3,:);q4=QV(4,:);q5=QV(5,:);
% P = eqPspm(Ls,Lt,Wtr,q1',q2',q3',q4',q5');
% syms q1 q2 q3 q4 q5
% Pcell{iiter}=P(2,:,5);
% indft=find(P(2,1:end-1,5).*P(2,2:end,5)<0);

q1=QV(1,:);q2=QV(2,:);q3=QV(3,:);q4=QV(4,:);q5=QV(5,:);

P = eqPspm(Ls,Lt,Wtr,q1',q2',q3',q4',q5');
indft=find(P(2,1:end-1,5).*P(2,2:end,5)<0);

q1=QV(1,indft);q2=QV(2,indft);q3=QV(3,indft);q4=QV(4,indft);q5=QV(5,indft);
dq1=DQV(1,indft);dq2=DQV(2,indft);dq3=DQV(3,indft);dq4=DQV(4,indft);dq5=DQV(5,indft);
dhGdt=sum((eqdHsp(q1',q2',q3',q4',q5').*DQV(:,indft)')');
indft=indft(find(dhGdt<0));%%%%REVIEWWWWWWWWW
if indft(1)==1
    indft=indft(2:end);
end
syms q1 q2 q3 q4 q5
disp(ti(indft(1)))

indft
if ~isempty(indft)
    
    Q0b=Y(indft(1),1:5)';
    DQ0b=Y(indft(1),6:10)';
    
    R = [1 1 1 1 -1; 0 0 0 0 1; 0 0 0 -1 0; 0 0 -1 0 0; 0 1 0 0 0];
    Dq = eqDqsp(Q0b(2),Q0b(3),Q0b(4),Q0b(5));
    Jn = eqJnsp(Ls,Lt,Q0b(1),Q0b(2),Q0b(3),Q0b(4),Q0b(5));
    Q0a=R*Q0b;
    DQ0a=R*(eye(5)-(Dq^-1)*Jn'*((Jn*(Dq^-1)*Jn')^-1)*Jn)*DQ0b;
    [ti,Y] = ode45(@AMBER,[0 ti(indft(1))*1.1],[Q0a;DQ0a],options);
end
QV=Y(:,1:5)';
DQV=Y(:,6:10)';

%pause
%PlotTraj
end

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
figure(5)
plot(ti,QV); hold on, grid on
legend('q1','q2','q3','q4','q5')
plot(ti,thpa),grid on
legend('sf','sk','sh','nsh','nsk');
title('Angles')

t=tf/2+[-Ls-Lt -Lt 0 0 0]*q/vhip;
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
figure(8)
plot(ti,M*QV); hold on, grid on
legend('q1','q2','q3','q4','q5')
plot(ti,M*thpa),grid on
legend('ph','ms','sk','nsk','tor')
title('vars')
%%
figure(9)
q1=QV(1,:);q2=QV(2,:);q3=QV(3,:);q4=QV(4,:);q5=QV(5,:);
vyHdti=vyHd(ti');
yV=eqya(q1,q2,q3,q4,q5)-vyHdti(1:4,:);
plot(ti,yV),grid on
title('Error Tracking')
syms q1 q2 q3 q4 q5;
%%