min_angle=20;
dtr = pi/180;
R=6371;
h= 735;%要改的部分
simple_conic=asin(R*sin(pi/2+min_angle*dtr)/(R+h))/dtr
r=R*(90-min_angle-simple_conic)*dtr;
c=pi*r^2;
r*2;

