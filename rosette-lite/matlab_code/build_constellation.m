clear all; close all; clc;
global No_leo cycle No_snap No_fac tStart tStop dT constellation inc
dT = 60;
tStart = 0;
dtr = pi/180;
rtd = 180/pi;   
cycle= 86400;    
No_snap = floor(cycle/dT)+1;
No_fac=0;
remMachine = stkDefaultHost;
delete(get(0,'children'));  
conid=stkOpen(remMachine);

scen_open = stkValidScen;
if scen_open == 1
    rtn = questdlg('Close the current scenario?');
    if ~strcmp(rtn,'Yes')
        stkClose(conid)
    else
        stkUnload('/*')
    end
end

disp('Create a new scenario');
stkNewObj('/','Scenario','rosette_1');
disp('Set scenario time period');
stkSetTimePeriod('1 Jan 2018 0:00:00.0','1 Dec 2020 10:00:00.0','GREGUTC');
stkSetEpoch('1 Jan 2019 0:00:00.0','GREGUTC');
cmd1 = ['SetValues "1 Jan 2019 0:00:00.0" ' mat2str(dT)];
cmd1 = [cmd1 ' 0.1'];
rtn = stkConnect(conid,'Animate','Scenario/rosette_1',cmd1);
rtn = stkConnect(conid,'Animate','Scenario/rosette_1','Reset');
disp('Set up the propagator and nodes for the satellites');
% [parameter] = Create_LEO(conid,'../etc/parameter-Rosette-High.xlsx');
% Create_link(conid,'Chain_High_High','../etc/parameter-link-High-16.xlsx','blue','Rosette_High','Rosette_High');
% config file
[parameter] = Create_LEO(conid,'../etc/parameter-StarLink.xlsx');
% Create_link(conid,'Chain_Low_Low','../etc/parameter-link-Low-225.xlsx','red','Rosette_Low','Rosette_Low');
% Create_link(conid,'Chain_High_Low','../etc/parameter-link-High-Low-16-256.xlsx','yellow','Rosette_High','Rosette_Low');
% Create_Fac(conid);
% % 
disp('save position info');
[position, position_cbf]=Create_location(dT);
filename = [constellation '\position_twobody.mat'];
save(filename,'position','position_cbf');
% disp('save delay info');
% for t = 1:cycle
%     [delay] = Create_delay(position_cbf,t,inc);
% end
% for t = 1:cycle
%     [delay] = Create_delay_hierarchi(position_cbf,position_cbf_low,t,inc);
% end
% stkExec( conid, 'Animate Scenario/rosette_1  Reset' );
% stkExec( conid, 'Animate Scenario/rosette_1  Start' );

stkClose(conid)
stkClose
