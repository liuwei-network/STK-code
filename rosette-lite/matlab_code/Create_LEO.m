function [parameter] = Create_LEO(conid,path)
% Create LEOs in STK
% input:
%   conid: used to connect to STK
%   path: configuration file path of mega-constellations
    global No_leo  cycle S_snap tStop constellation dT inc;
    color_list={'red','green', 'white', 'gray' ,'blue' ,'yellow', 'purple', 'pink' ,'brown', 'cyan' ,'RoyalBlue', 'DarkTurquoise', 'chocolate' ,'OliveDrab', 'orange' ,'gold' ,'LavenderBlush1', 'DarkSeaGreen', 'HotPink','azure1'};
    parameter = readtable(path);
    parameter = parameter.Value;
    Sat_name = parameter{1,1};
    constellation=Sat_name;
    Altitude = str2num(parameter{2,1});
    tStop = cycle;
%     tStop = 86400*60;%when to stop, a month
    dtr = pi/180;
    inc = str2num(parameter{3,1})*dtr;%Inclination
    m_top = str2num(parameter{4,1});
    leo_plane = str2num(parameter{5,1});%number of orbits
    No_leo = str2num(parameter{6,1});%number of satellite
    S=No_leo/leo_plane;%satellites per orbit
    SimpleCone=parameter{7,1};
    orbit_color=strcat(' ',parameter{8,1});
    sensor_color=strcat(' ',parameter{9,1});
    sensor_flag=str2num(parameter{10,1});
    F_R=str2num(parameter{11,1});
    diff_color=str2num(parameter{12,1});
    
    disp('Satellites:');
    disp(No_leo);
    if (inc>80*dtr&&inc<100*dtr&&F_R==0)
        temp=180;
    else
        temp=360;
    end
    for i =1:No_leo
        orbit_n=mod(i-1,leo_plane)+1;
        ra = mod(temp*(i-1)/leo_plane,temp)*dtr;
        if (F_R==1)
            ma=mod(mod(m_top*temp*(i-1)/leo_plane,temp)+(360/S)*floor((i-1)/leo_plane),360)*dtr;
        else 
            ma=(floor((i-1)/leo_plane))*(360/S)*dtr;
        end
%         Rosette
%         ma = mod((m_top)*360*(i-1)/leo_plane,360)*dtr;
        sat_S = strcat('Sat_',Sat_name,num2str(i));
        sensor_s = strcat('Sensor_',Sat_name,num2str(i));
        stkNewObj('*/','Satellite',sat_S);
        sat_S = strcat('*/Satellite/',sat_S);
        stkSetPropClassical(sat_S,'TwoBody','J2000',0.0,tStop,dT,0,6371000 + Altitude * 10^3,0.0,inc,0.0,ra,ma);%insert a satellite
%         stkSetPropClassical(sat_S,'J4Perturbation','J2000',0.0,tStop,dT,0,6371000 + Altitude * 10^3,0.0,inc,0.0,ra,ma);%insert a satellite
        if(sensor_flag==1)
            stkNewObj(sat_S,'Sensor',sensor_s);

            cmd2 = ['Define ' sat_S];
            cmd2 = [cmd2 '/Sensor/'];
            cmd2 = [cmd2,sensor_s];
            cmd2 = strcat(cmd2, ' SimpleCone ',32,SimpleCone);
            stkExec(conid,cmd2);
            sensor_S = strcat(sat_S,'/Sensor/');
            sensor_S = strcat(sensor_S,sensor_s);
            sensor_no = ['Graphics ',sensor_S];
            FillStyle= [sensor_no,' Fill On '];
            stkExec(conid,FillStyle);
            FillTranslucency =[sensor_no,' FillTranslucency 90 '];%Translucency of sensor in 2D
            stkExec(conid,FillTranslucency);
            FillTranslucency_3D=strcat('VO ',32,sensor_S,' Translucency  90 ');
            stkExec(conid,FillTranslucency_3D);
            temp_c=strcat(sensor_no,' SetColor ', 32,sensor_color);
            stkExec(conid,temp_c);
            sen_lineStyle= [sensor_no,' LineStyle Dashed'];
            stkExec(conid,sen_lineStyle);
        end
%         disp(sensor_S);
        sat_no = ['Graphics ',sat_S];
        satcolor_o= [sat_no ,'  Basic Show On Label Off Color '];
%         disp(orbit_color);
        if (diff_color==1)
            index=mod(orbit_n-1,19)+1;
            orbit_color=strcat(' ',color_list{index});
%             disp(orbit_color);
        end
        satcolor_o= strcat(satcolor_o,32,orbit_color);
        stkExec(conid,satcolor_o);
        lineStyle= [sat_no,' Basic Show On Label Off LineStyle Dot'];
%         stkExec(conid,lineStyle);
        num_leo(i)=i;
    end
    save('Num_leo.mat','num_leo','leo_plane');
    mkdir(strcat(constellation,'\\delay'))

end
