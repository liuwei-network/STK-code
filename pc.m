stkInit
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
disp('Set scenario time period');
stkSetTimePeriod('14 April 2022 00:00:00.000','5 June 2022 00:00:00.000','GregorianUTC');%GREGUTC
stkSetEpoch('14 Apr 2022 00:00:00.000','GregorianUTC');
stkSyncEpoch;
rtn0 = stkConnect(conid,'Animate','*','Reset'); % Reset animation time.
start_time='2022-04-14 00:00:00';
end_time='2022-06-05 00:00:00';
epochtime=datevec(start_time);
%此文件是包含尖峰和平台式变轨
% man_path='.\conjunction_event_1km_maneuver.csv';
%此文件只包含尖峰
man_path='.\conjunction_event_brust_maneuver.csv';
man=readtable(man_path);
rows=height(man);
%3是tca之前最新的，2是tca-12之前一周的
tle_path='.\maneuver_tle3\';
for i=1:rows
    disp([num2str(i),'/',num2str(rows)]);
    ID=man.ID{i};
    cp=strsplit(ID,'-');
    tca=man.tca_time{i};
    tca=strsplit(tca,'.');
    tca=tca{1};
    tle_path_2=[tle_path,ID,'-',tca];
    tle_path_2=strrep(tle_path_2,':','_');
    obj_path='*/AdvCAT/Cat';
    stkNewObj('*/','AdvCAT', 'Cat');%插入CAT实例
    cmd_t='ACAT */AdvCAT/Cat Threshold 100000';
    rntdata_t=stkExec(conid,cmd_t); 
    tca_time=datevec(tca);
    cat_start_time=tca_time;
    cat_end_time=tca_time;
    cat_start_time(3)=cat_start_time(3)-1;
    cat_end_time(3)=cat_end_time(3)+1;

    
%     cmd_t=['ACAT */AdvCAT/Cat TimePeriod "',strrep(datestr(cat_start_time),'-',' '),'.000" "',strrep(datestr(cat_end_time),'-',' '),'.000"']
%     rntdata_t=stkExec(conid,cmd_t);  

    cmd_t=['ACAT */AdvCAT/Cat Primary Add "',tle_path_2, '\',cp{1},'.tle"'];
    rntdata_t=stkExec(conid,cmd_t); 
    
    cmd_t=['ACAT */AdvCAT/Cat Secondary Add "',tle_path_2, '\',cp{2},'.tle"'];
    rntdata_t=stkExec(conid,cmd_t);     
    
    cmd_t='ACAT */AdvCAT/Cat Compute ShowProgress On';
    rntdata_t=stkExec(conid,cmd_t); 
%   
    tstart = etime(cat_start_time,epochtime);
    tstop=etime(cat_end_time,epochtime);
    %2是变轨前，3是变轨后，4是变轨后但是不限制tca时间
    outputname=['.\stk_pc4\',ID,'-',strrep(tca,':','_'),'.mat'];
    %之前的版本，因为限制了时间，所以有些没有event
%     [cat_data, secName_1] = stkReport(obj_path,'Pc',tstart,tstop,60);
    [cat_data, secName_1] = stkReport(obj_path,'Pc');
    save(outputname,'cat_data');
    stkUnload(obj_path);
end
