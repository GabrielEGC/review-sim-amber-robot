function dxdt = AMBERt(t,x)
    dq1=x(6);q1=x(1);
    dq2=x(7);q2=x(2);
    dq3=x(8);q3=x(3);
    dq4=x(9);q4=x(4);
    dq5=x(10);q5=x(5);
    
    vyHdt=vyHd(t);
    yd=vyHdt(1:4);
    dyd=vyHdt(5:8);
    ddyd=vyHdt(9:12);
    
    B=[zeros(1,4);diag([1 1 1 1])];
    phq = eqphqsp(dq1,dq2,dq3,dq4,dq5,q1,q2,q3,q4,q5);
    Dq = eqDqsp(q2,q3,q4,q5);
    
    ep=50;kd=2*ep;kp=ep^2;
    L2fya=eqLfyax*[x(6:10);-(Dq^-1)*phq];
    Lgfya=eqLfyadq*(Dq^-1)*B;
    
    
    v=ddyd-kd*(eqLfya(dq1,dq2,dq3,dq4,dq5)-dyd)-kp*(eqya(q1,q2,q3,q4,q5)-yd);
    u=-Lgfya^-1*(L2fya-v);
    
    dxdt = [x(6:10);-(Dq^-1)*phq+(Dq^-1)*B*u];
end