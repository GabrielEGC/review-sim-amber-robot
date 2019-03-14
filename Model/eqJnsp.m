function Jn = eqJnsp(Ls,Lt,q1,q2,q3,q4,q5)
%EQJNSP
%    JN = EQJNSP(LS,LT,Q1,Q2,Q3,Q4,Q5)

%    This function was generated by the Symbolic Math Toolbox version 6.2.
%    13-Mar-2019 21:02:24

t2 = q1+q2+q3+q4-q5;
t3 = cos(t2);
t4 = Ls.*t3;
t5 = q1+q2+q3+q4;
t6 = cos(t5);
t7 = Lt.*t6;
t8 = q1+q2;
t9 = cos(t8);
t10 = t4+t7;
t11 = sin(t2);
t12 = Ls.*t11;
t13 = sin(t5);
t14 = Lt.*t13;
t15 = sin(t8);
t16 = t12+t14;
Jn = reshape([t4+t7-Lt.*t9-Ls.*cos(q1),t12+t14-Lt.*t15-Ls.*sin(q1),t4+t7-Lt.*t9,t12+t14-Lt.*t15,t10,t16,t10,t16,-t4,-t12],[2, 5]);
