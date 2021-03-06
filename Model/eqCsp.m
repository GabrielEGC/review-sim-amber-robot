function C = eqCsp(Csa,Csk,Cth,Ctk,Ctrh,Ls,Lt,Wtr,q1,q2,q3,q4,q5)
%EQCSP
%    C = EQCSP(CSA,CSK,CTH,CTK,CTRH,LS,LT,WTR,Q1,Q2,Q3,Q4,Q5)

%    This function was generated by the Symbolic Math Toolbox version 6.2.
%    13-Mar-2019 21:02:22

t2 = q1+q2;
t3 = sin(t2);
t4 = sin(q1);
t5 = q1+q2+q3+q4;
t6 = sin(t5);
t7 = q1+q2+q3+q4-q5;
t8 = sin(t7);
t9 = Lt.*t6;
t10 = Csk-Ls;
t11 = cos(t2);
t12 = cos(q1);
t13 = Lt.*t11;
t14 = Ls.*t12;
t15 = q1+q2+q3;
t16 = cos(t5);
t17 = cos(t7);
C = reshape([t4.*t10,-t10.*t12,0.0,Cth.*t3-Ls.*t4-Lt.*t3,t13+t14-Cth.*t11,0.0,-Ls.*t4-Lt.*t3-Ctrh.*sin(t15),t13+t14+Ctrh.*cos(t15),Wtr.*(1.0./2.0),t9-Ctk.*t6-Ls.*t4-Lt.*t3,t13+t14+Ctk.*t16-Lt.*t16,Wtr,t9-Csa.*t8-Ls.*t4+Ls.*t8-Lt.*t3,t13+t14+Csa.*t17-Ls.*t17-Lt.*t16,Wtr],[3, 1, 5]);
