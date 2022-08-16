clear
remMachine = stkDefaultHost;
conid=stkDefaultConID;
scen_open = stkValidScen;
if scen_open == 1
   rtn = questdlg('Close the current scenario?');
   if ~strcmp(rtn,'Yes')
      stkClose(conid)
      return
   else
      stkUnload('/*')
   end
end
disp('Create a new scenario: SatelliteConjunction');
stkNewObj('Scenario','','SatelliteConjunction');

%参数配置
starlink=load('starlink-1609.txt');
dT=1;
only_propagate_at_tle_interval=1;
coor='J2000';


disp('Set scenario time period');
% stkSetTimePeriod('22 May 2019 00:00:00.000','20 July 2022 00:00:00.000','GregorianUTC');%GREGUTC
% stkSetEpoch('22 May 2019 00:00:00.000','GregorianUTC');
stkSetTimePeriod('14 April 2022 00:00:00.000','5 June 2022 00:00:00.000','GregorianUTC');%GREGUTC
stkSetEpoch('14 April 2022 00:00:00.000','GregorianUTC');
start_time='2022-04-14 00:00:00';
end_time='2022-06-05 00:00:00';
epochtime=datevec(start_time);
stkSyncEpoch;
rtn0 = stkConnect(conid,'Animate','*','Reset'); % Reset animation time.
dtr = pi/180;

tlepath='.\all_by_id\';
outputdir='.\TEST\';
tlefilesdir='.\starlink_1609_for_stk\';
% tleDir  = dir([tlepath '*.csv']); % 遍历所有txt格式文件
% for i = 1:length(tleDir)          % 遍历结构体就可以一一处理tle了
%     path=[tlepath,tleDir(i).name];

for sat_i=1:length(starlink)
    try
        path=[tlepath,num2str(starlink(sat_i)),'.csv'];
%         path=[tlepath,'4160.csv'];
        disp(path);
        tles=readtable(path);
        tles(:,1:2) =[];
        tles=unique(tles);
        NORAD_CAT_ID=tles.NORAD_CAT_ID(1);
        tles=sortrows(tles,4);
        rows=height(tles);
        progation_data = double.empty(0,17);
        index=0;
        
        sat_name= num2str(NORAD_CAT_ID);
        OBJECT_NAME=tles.OBJECT_NAME(1);
        tlefilespath=[tlefilesdir,'\',sat_name,'\'];
        satPath = strcat('*/Satellite/' , sat_name);
        stkNewObj('*/','Satellite', sat_name);
        
        for i = 1:rows-1
            EPOCH=tles.EPOCH{i};
            if datenum(EPOCH) < datenum(start_time)
                continue
            end
            if datenum(EPOCH) >datenum(end_time)
                break
            end
            if tles.EPOCH{i}==tles.EPOCH{i+1}
                continue
            end
            tstart = etime(datevec(EPOCH),epochtime);
            tstop=etime(datevec(tles.EPOCH{i+1}),epochtime);
            MEAN_ANOMALY=tles.MEAN_ANOMALY(i); 
            ECCENTRICITY=tles.ECCENTRICITY(i)/10;
            INCLINATION=tles.INCLINATION(i);
            RA_OF_ASC_NODE=tles.RA_OF_ASC_NODE(i);
            ARG_OF_PERICENTER=tles.ARG_OF_PERICENTER(i);
            SEMIMAJOR_AXIS=tles.SEMIMAJOR_AXIS(i);
            MEAN_MOTION=tles.MEAN_MOTION(i);
            MEAN_MOTION_DOT=tles.MEAN_MOTION_DOT(i);
            MEAN_MOTION_DDOT=tles.MEAN_MOTION_DDOT(i);
            BSTAR=tles.BSTAR(i);
            TLE_LINE1=tles.TLE_LINE1(i);
            temp=strsplit(TLE_LINE1{1});
            orbitepoch=temp{4};
            
            disp([sat_name,' update at ',EPOCH]);
%             tlefile=[tlefilespath,strrep(EPOCH,':','_'),'.txt'];
%             vehNames_t = atbTLERead(tlefile,[num2str(i),'_']);
%             satPath = strcat('*/Satellite/' , vehNames_t{1});
%             stkNewObj('*/','Satellite', vehNames_t{1});
%             stkSetPropSGP4(satPath,tstart,tstop, tstop-tstart, atbTLEInfo(vehNames_t{1}));
            stkSetPropClassical(satPath,'HPOP','J2000',tstart,tstop,tstop-tstart,tstart,SEMIMAJOR_AXIS*1000,ECCENTRICITY,INCLINATION*dtr,ARG_OF_PERICENTER*dtr,RA_OF_ASC_NODE*dtr,MEAN_ANOMALY*dtr);
%             stkSetPropSGP4(satPath,tstart,tstop,tstop-tstart,num2str(NORAD_CAT_ID),orbitepoch,MEAN_MOTION,ECCENTRICITY,INCLINATION*dtr,ARG_OF_PERICENTER*dtr,RA_OF_ASC_NODE*dtr,MEAN_ANOMALY*dtr,MEAN_MOTION_DOT,MEAN_MOTION_DDOT,BSTAR);
%             stkSetPropClassical(satPath,'HPOP','ICRF',tstart,tstop,tstop-tstart,tstart,SEMIMAJOR_AXIS*1000,ECCENTRICITY,INCLINATION*dtr,ARG_OF_PERICENTER*dtr,RA_OF_ASC_NODE*dtr,MEAN_ANOMALY*dtr);
            stkTimePeriod(satPath,'GregorianUTC');

            if only_propagate_at_tle_interval==1               
                %ICRF坐标系
                if strcmp(coor,'ICRF')==1
                    [secData_LLA, secName_1] = stkReport(satPath,'My Position',tstop, tstop+1,10);
                    [secData_element, secName_2] = stkReport(satPath,'ICRF elements',tstop, tstop+1,10);
%                     [secData_LLA, secName_1] = stkReport(satPath,'My Position',tstart, tstart+1,10);
%                     [secData_element, secName_2] = stkReport(satPath,'ICRF elements',tstart, tstart+1,10);
                else
                %J2000坐标系
%                     [secData_LLA, secName_1] = stkReport(satPath,'LLA Position',tstop, tstop+1,10);
%                     [secData_element, secName_2] = stkReport(satPath,'Classical Orbit Elements',tstop, tstop+1,10);
%                     [secData_J2000, secName_3] = stkReport(satPath,'J2000 Position Velocity',tstop, tstop+1,10);
                    [secData_LLA, secName_1] = stkReport(satPath,'LLA Position',tstart, tstart+1,10);
                    [secData_element, secName_2] = stkReport(satPath,'TEMEofEpoch elements',tstart, tstart+1,10);
                    [secData_J2000, secName_3] = stkReport(satPath,'TEMEofEpoch Position Velocity',tstart, tstart+1,10);
                end
            else
                tstart_report=ceil(tstart/10)*10;
                tstop_report=ceil(tstop/10)*10;
                %ICRF坐标系
                if strcmp(coor,'ICRF')==1
                    [secData_LLA, secName_1] = stkReport(satPath,'My Position',tstart_report, tstop_report, dT);
                    [secData_element, secName_2] = stkReport(satPath,'ICRF elements',tstart_report, tstop_report, dT);
                else
                %J2000坐标系
                    [secData_LLA, secName_1] = stkReport(satPath,'LLA Position',tstart_report, tstop_report, dT);
                    [secData_element, secName_2] = stkReport(satPath,'Classical Orbit Elements',tstart_report, tstop_report, dT);
                    [secData_J2000, secName_3] = stkReport(satPath,'J2000 Position Velocity',tstart_report, tstop_report, dT);
                end
            end
            
            t=  stkFindData(secData_LLA{1}, 'Time');           
            if strcmp(coor,'ICRF')==1
                lat = stkFindData(secData_LLA{1}, 'Detic Latitude');
                long = stkFindData(secData_LLA{1}, 'Detic Longitude');
                alt = stkFindData(secData_LLA{1}, 'Detic Altitude');
                x = stkFindData(secData_LLA{1}, 'x');
                y = stkFindData(secData_LLA{1}, 'y');
                z = stkFindData(secData_LLA{1}, 'z');
                vx = stkFindData(secData_LLA{1}, 'Velocity x');
                vy = stkFindData(secData_LLA{1}, 'Velocity y');
                vz = stkFindData(secData_LLA{1}, 'Velocity z');                
            else
                lat = stkFindData(secData_LLA{1}, 'Lat');
                long = stkFindData(secData_LLA{1}, 'Lon');
                alt = stkFindData(secData_LLA{1}, 'Alt');   
                x = stkFindData(secData_J2000{1}, 'x');
                y = stkFindData(secData_J2000{1}, 'y');
                z = stkFindData(secData_J2000{1}, 'z');
                vx = stkFindData(secData_J2000{1}, 'vx');
                vy = stkFindData(secData_J2000{1}, 'vy');
                vz = stkFindData(secData_J2000{1}, 'vz');                  
            end
            
            semi = stkFindData(secData_element{1}, 'Semi-major Axis');
            ecc = stkFindData(secData_element{1}, 'Eccentricity');
            inc = stkFindData(secData_element{1}, 'Inclination');
            raan = stkFindData(secData_element{1}, 'RAAN');
            arg = stkFindData(secData_element{1}, 'Arg of Perigee');
            truea = stkFindData(secData_element{1}, 'True Anomaly');
            meana = stkFindData(secData_element{1}, 'Mean Anomaly');

            progation_data=[progation_data;zeros(length(alt),17)];
            for j = 1:length(alt)
        %         progation_data(1,j) = datetime(epochtime)+seconds(fix(t(j)));
                progation_data(j+index,1) = t(j);
                progation_data(j+index,2) = lat(j)/dtr;%%lat
                progation_data(j+index,3) = long(j)/dtr;%%long
                progation_data(j+index,4) = alt(j);%height
                progation_data(j+index,5) = semi(j);
                progation_data(j+index,6) = ecc(j);
                progation_data(j+index,7) = inc(j);
                progation_data(j+index,8) = raan(j);
                progation_data(j+index,9) = arg(j);
                progation_data(j+index,10) = truea(j);
                progation_data(j+index,11) = meana(j);
                progation_data(j+index,12) = x(j);
                progation_data(j+index,13) = y(j);
                progation_data(j+index,14) = z(j);
                progation_data(j+index,15) = vx(j);
                progation_data(j+index,16) = vy(j);
                progation_data(j+index,17) = vz(j);
            end
            index=length(alt)+index;
%             stkUnload(satPath);
            
        end
        outputname=[outputdir,num2str(NORAD_CAT_ID),'.mat'];
        save(outputname,'progation_data');
        disp([num2str(NORAD_CAT_ID),': got data!']);
        
        stkUnload(satPath);
    catch ME
        rethrow(ME);
    end        
end

