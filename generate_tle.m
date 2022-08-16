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
stkSetTimePeriod('11 Apr 2022 18:42:22.949','12 Apr 2022 18:42:22.949','GregorianUTC');%GREGUTC
stkSetEpoch('11 Apr 2022 18:42:22.949','GregorianUTC');
stkSyncEpoch;
rtn0 = stkConnect(conid,'Animate','*','Reset'); % Reset animation time.

TLEPath = 'C:\Users\DELL\OneDrive\文档\MATLAB\44957\';        % tle
tleDir  = dir([TLEPath '*.txt']); % 遍历所有txt格式文件
for i = 1:length(tleDir)          % 遍历结构体就可以一一处理tle了
    path=[TLEPath,tleDir(i).name]
    name=strcat(num2str(i),'_');
    vehNames_t = atbTLERead(path,name);
    satPath = strcat('*/Satellite/' , string(vehNames_t{1}));
    stkNewObj('*/','Satellite', vehNames_t{1});
    stkSetPropSGP4(satPath, 0, 24*60*60, 60, atbTLEInfo(vehNames_t{1}));
    stkTimePeriod(satPath,'GregorianUTC')
end

disp('generate TLE')
stkExec(conid,'Units_SetConnect / Date "GregorianUTC"');
for i = 1:(length(tleDir)-1)          % 遍历结构体就可以一一处理卫星,生成tle Sampling
    name=strcat(num2str(i),'_44967');
    satPath = strcat('*/Satellite/' , name);
    new_sat=strcat(num2str(i),'_sampling');
    cmd1_t=['GenerateTLE ',satPath,' Sampling "11 Apr 2022 18:42:22.949" "12 Apr 2022 18:42:22.949" 60.0 "11 Apr 2022 18:42:22.949" 44967 20 0.0004 SGP4 ',new_sat];
    rntdata_t=stkExec(conid,cmd1_t);
    
end


stkExec(conid,'Units_SetConnect / Date "GregorianUTC"');
disp('generate TLE')
%generate TLE
for i = 1:(length(tleDir)-1)          % 遍历结构体就可以一一处理卫星,生成tle  Point
    name=strcat(num2str(i),'_44967');
    satPath = strcat('*/Satellite/' , name);
    new_sat=strcat(num2str(i),'_point');
    cmd1_t=['GenerateTLE ',satPath,' Point "11 Apr 2022 18:42:22.949" 44967 20 0.0004 SGP4 ',new_sat];
    rntdata_t=stkExec(conid,cmd1_t);
    
end
