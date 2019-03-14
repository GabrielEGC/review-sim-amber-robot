syms q1 q2 q3 q4 q5
[Cfh,Cft,Csa,Csk,Cth,Ctk,Ctrh,If,Is,It,Itr,Lf,Ls,Lt,Ltr,Wtr,Mf,Ms,Mt,Mtr]=BodyProperties(69,1.74);
P = eqPsp(Ls,Lt,Wtr,q1,q2,q3,q4,q5);
P(2,:,5);
matlabFunction(simplify(jacobian(P(2,:,5),[q1,q2,q3,q4,q5])),'File','eqdHsp');