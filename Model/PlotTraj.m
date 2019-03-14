%close all
%% plotting 3d
gaitpercent1st=ti;
refq1=QV(1,:);%*0.7
refq2=QV(2,:);
refq3=QV(3,:);
refq4=QV(4,:);
refq5=QV(5,:);
NsimT=floor(ti(end)*100);
Tti=ti(end)/NsimT;
nTti=1;
for k=1:length(gaitpercent1st)
    if gaitpercent1st(k)>nTti*Tti
    
    %disp(gaitpercent1st(k))
    pst(:,:,k)= [0;0;0]; % adding support toe
    P=eqPsp(Ls,Lt,Wtr,refq1(k),refq2(k),refq3(k),refq4(k),refq5(k));
    p1(:,:,k)= P(:,:,1); 
    p2(:,:,k)= P(:,:,2);
    p3(:,:,k)= P(:,:,3);
    p4(:,:,k)= P(:,:,4);
    p5(:,:,k)= P(:,:,5);
    %pbt(:,:,k)=(p3(:,:,k)+p4(:,:,k))/2; % adding back
%     R = eqRsp(refq1(k),refq2(k),refq3(k),refq4(k),refq5(k));
%     r04(:,:,k)=R(:,:,4);
    %pft(:,:,k)=p4(:,:,k)+r04(:,:,k)*[Ltr;0;pbt(2,1,k)];
    C=eqCsp(Csa,Csk,Cth,Ctk,Ctrh,Ls,Lt,Wtr,refq1(k),refq2(k),refq3(k),refq4(k),refq5(k));
    c1(:,:,k)=C(:,:,1);
    c2(:,:,k)=C(:,:,2);
    c3(:,:,k)=C(:,:,3);
    c4(:,:,k)=C(:,:,4);
    c5(:,:,k)=C(:,:,5);

    figure(10)

     plot3(p1(1,:,k),p1(3,:,k),p1(2,:,k),'bo'), hold on, grid on,
     plot3(pst(1,:,k),pst(3,:,k),pst(2,:,k),'co'),
     line([pst(1,:,k);p1(1,:,k)],[pst(3,:,k);p1(3,:,k)],[pst(2,:,k);p1(2,:,k)],'Color','g','linewidth',2),
     plot3(p2(1,:,k),p2(3,:,k),p2(2,:,k),'go'),
     plot3(p3(1,:,k),p3(3,:,k),p3(2,:,k),'ko'),
     line([p1(1,:,k);p2(1,:,k)],[p1(3,:,k);p2(3,:,k)],[p1(2,:,k);p2(2,:,k)],'linewidth',2),
     line([p2(1,:,k);p3(1,:,k)],[p2(3,:,k);p3(3,:,k)],[p2(2,:,k);p3(2,:,k)],'Color','r','linewidth',2),
     plot3(p4(1,:,k),p4(3,:,k),p4(2,:,k),'ko'),
     plot3(p5(1,:,k),p5(3,:,k),p5(2,:,k),'go'),
     line([p3(1,:,k);p4(1,:,k)],[p3(3,:,k);p4(3,:,k)],[p3(2,:,k);p4(2,:,k)],'Color','k','linewidth',2),
     %line([pbt(1,:,k);pft(1,:,k)],[pbt(2,:,k);pft(2,:,k)],[pbt(3,:,k);pft(3,:,k)],'Color','k','linewidth',2),
     line([p4(1,:,k);p5(1,:,k)],[p4(3,:,k);p5(3,:,k)],[p4(2,:,k);p5(2,:,k)],'Color','r','linewidth',2),
     plot3(c1(1,:,k),c1(3,:,k),c1(2,:,k),'co'),
     plot3(c2(1,:,k),c2(3,:,k),c2(2,:,k),'go'),
     plot3(c3(1,:,k),c3(3,:,k),c3(2,:,k),'bo'),
     plot3(c4(1,:,k),c4(3,:,k),c4(2,:,k),'ko'),
     plot3(c5(1,:,k),c5(3,:,k),c5(2,:,k),'bo'),
     hold off
     axis([-1.5 1.5 -1.5 1.50 -0.2 1.2]), 
     view(0,0)
     title('View')
     xlabel('x')
     ylabel('y')
     zlabel('z')
     drawnow
     nTti=nTti+1;
     
    end
     
end