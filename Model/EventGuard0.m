function [value, isterminal, direction] = EventGuard(T,Y,Ls,Lt,Wtr)

q1=Y(1);q2=Y(2);q3=Y(3);q4=Y(4);q5=Y(5);
DQV(:,1)=Y(6:10);

P = eqPspm(Ls,Lt,Wtr,q1',q2',q3',q4',q5');
dhGdt=sum((eqdHsp(q1',q2',q3',q4',q5').*DQV(:,1)')');

value      = (dhGdt<0 & P(2,1,5)<0 & T>0.2 & P(2,1,5)>-5e-3)-0.5; %%
isterminal = 1;   % Stop the integration
direction  = 0;
end


