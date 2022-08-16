dtr=pi/180;
b=70*dtr; %\beta
N=16;
k=2;
N=N^(k+1);
s=25*dtr;%\phi
R=acos(1/(sqrt(3)*tan(pi/6*N/(N-2))));
H=6371*(1/(cos(R)-sin(R)*tan(s))-1)