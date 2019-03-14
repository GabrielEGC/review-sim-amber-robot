syms t
alp=[0.0117 8.6591 0.1153 -2.1554 0.2419
-0.1739 13.6644 0.0397 3.3222 0.3332
-0.3439 10.5728 0.0464 -0.8606 0.6812
-0.0166 10.4416 -0.0033 3.2976 0.0729];
yHd=exp(-alp(:,4)*t).*(alp(:,1).*cos(alp(:,2)*t)+alp(:,3).*sin(alp(:,2)*t))+alp(:,5);
dyHd=diff(yHd,t);
ddyHd=diff(dyHd,t);
vyHd=[yHd;dyHd;ddyHd];
matlabFunction(vyHd,'file','vyHd');