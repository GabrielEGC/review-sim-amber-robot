function dxdt = AMBER(t,x)
    dq1=x(6);q1=x(1);
    dq2=x(7);q2=x(2);
    dq3=x(8);q3=x(3);
    dq4=x(9);q4=x(4);
    dq5=x(10);q5=x(5);
    
    B=[zeros(1,4);diag([1 1 1 1])];
    phq = eqphqsp(dq1,dq2,dq3,dq4,dq5,q1,q2,q3,q4,q5);
    Dq = eqDqsp(q2,q3,q4,q5);
    
    ep=100;
    L2fy=eqLfyx(dq1,dq2,q1,q2)*[x(6:10);-(Dq^-1)*phq];
    Lgfy=eqLfydq(q1,q2)*(Dq^-1)*B;
    u=-Lgfy^-1*(L2fy+2*ep*eqLfy(dq1,dq2,dq3,dq4,dq5,q1,q2)+ep^2*eqy(q1,q2,q3,q4,q5));
    
    dxdt = [x(6:10);-(Dq^-1)*phq+(Dq^-1)*B*u];
end