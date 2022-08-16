clear all; close all; clc;
global cycle No_snap No_fac No_leo tStart tStop dT constellation leo_plane
dT = 60;
tStart = 0;
dtr = pi/180;
rtd = 180/pi;
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
stkNewObj('/','Scenario','Matlab_Basic');
disp('Set scenario time period');
stkSetTimePeriod('25 Oct 2021 0:00:00.0','25 Oct 2021 10:00:00.0','GREGUTC');
stkSetEpoch('25 Oct 2021 0:00:00.0','GREGUTC');
cmd1 = ['SetValues "25 Oct 2021 0:00:00.0" ' mat2str(dT)];
cmd1 = [cmd1 ' 0.1'];
rtn = stkConnect(conid,'Animate','Scenario/Matlab_Basic',cmd1);
rtn = stkConnect(conid,'Animate','Scenario/Matlab_Basic','Reset');
disp('Set up the propagator and nodes for the satellites');
[parameter] = Create_LEO(conid,'../etc/parameter-StarLink.xlsx');


% Create_link(conid,'Chain_Low_Low','white');
% Create_Fac(conid);
% inc = str2num(parameter{4,1})*dtr;
% 
% disp('save position info');
% [position, position_cbf]=Create_location(dT);
% filename = [constellation '\position.mat'];
% save(filename,'position','position_cbf');
% disp('save delay info');
% for t = 1:cycle
%     [delay] = Create_delay(position_cbf,t,inc);
% end
% stkExec( conid, 'Animate Scenario/Matlab_Basic  Reset' );
% stkExec( conid, 'Animate Scenario/Matlab_Basic  Start' );
% 
% stkClose(conid)
% stkClose
