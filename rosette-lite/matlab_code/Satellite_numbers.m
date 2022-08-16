T_times=15;%地球自转周期对卫星轨道周期的倍数，最好为整数，决定了轨道高度
Minimum_Elevation_Angle=20;%最小仰角限制，单位：度
T_satellite=24/T_times;%卫星周期
k=1.994426816;%const
R_E=6371;
dtr = pi/180;
% altitude=(((T_satellite^2)/k)^(1/3)-1)*R_E;
altitude=550;
disp(['altitude=',num2str(altitude)]);
% 
% temp=R_E/(R_E+altitude);
% tan_m=tan(dtr*Minimum_Elevation_Angle);
% temp1=(-2*tan_m*temp+2*(tan_m+1-temp)^(1/2))/2*(tan_m+1);
R_max=(acos(R_E*cos(Minimum_Elevation_Angle*dtr)/(R_E+altitude))-Minimum_Elevation_Angle*dtr);
% disp(d);
temp=atan(sec(R_max)/sqrt(3));
N=ceil(2*temp/(temp-30*dtr));
disp(['N=',num2str(N)]);
disp(['P=',num2str(N)]);
m=N-T_times;
disp(['m=',num2str(m)]);


temp=asin(sin(90*dtr+Minimum_Elevation_Angle*dtr)*R_E/(R_E+altitude))/dtr;
disp(['angle of sensor=',num2str(temp)]);