function [T,R,P]=DH_matrix(aa,bb,cc,dd)
% Devit Hartemberg Homogenius Matrix
% Input parametres=[ d theta r alpha]
% output paramtres=[T,R,P]
% T= transformation matrix
% R= Rotation matrix
% P= translation Matrix

% defining input data
if nargin == 1
    d=aa(1);
    th=aa(2);
    r=aa(3);
    alp=aa(4);
end
if nargin > 1
    d=aa(1);
    th=bb;
    r=cc;
    alp=dd;
end
% defining matrix elements
ct=cos(th);
st=sin(th);
ca=cos(alp);
sa=sin(alp);
% fixing matrix elements
if(alp==pi/2)
    ca=0; sa=1.0;
elseif(alp==-pi/2)
    ca=0; sa=-1.0;
end
if(alp==pi)
    ca=-1.0; sa=0.0;
elseif(alp==-pi)
    ca=-1.0; sa=0.0;
end
if(th==pi/2)
    ct=0; st=1.0;
elseif(th==-pi/2)
    ct=0; st=-1.0;
end
if(th==pi)
    ct=-1.0; st=0.0;
elseif(th==-pi)
    ct=-1.0; st=0.0;
end
% Transformation matrix
T=[ct   -st*ca     st*sa    r*ct;
   st    ct*ca    -ct*sa    r*st;
   0     sa        ca       d   ;
   0     0         0        1   ];
% defining outputs

    R=T(1:3,1:3);


    P=T(1:3,4);


end
    