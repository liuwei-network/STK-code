function [accMat] = Create_report()
global No_geo
global No_leo
global No_snap
global No_fac
global No_meo
global tStart
global tStop
global dT
load('Num_link.mat');
No_link=length(num_link)%%the number of link
%No_link=No_leo*(No_geo+No_fac);
accMatS = cell(1,No_link);
%distance = cell(1,No_link);
%delay = cell(1,No_link);
%%[secData1, secName1] = stkReport('Scenario/Matlab_Basic/Chain/Chain1', 'Time Ordered Access', tStart, tStop, dT);
for i=1:No_link
    len = cell(1,No_snap);
    beginTime = cell(1,No_snap);
    %link_no=num2str(num_link(i));
    link_no=link_str(i+1,:);
    info_link=strcat('Scenario/Matlab_Basic/Chain/Chain',link_no)
    [secData, secName] = stkReport(info_link, 'Time Ordered Access', tStart, tStop, dT);
    startTime=zeros(No_snap,1);
    stopTime=zeros(No_snap,1);
    duration=zeros(No_snap,1);
    if ~isempty(secData{1})
        link_no;
        startTime = stkFindData(secData{1}, 'Start Time');
        stopTime = stkFindData(secData{1}, 'Stop Time');
        duration = stkFindData(secData{1}, 'Duration');
        [secData, secName] = stkReport(info_link,'Access AER',tStart, tStop, dT);
        for j = 1:length(secData)
            len{j} = stkFindData(secData{j},'Range');
            beginTime{j} = stkFindData(secData{j},'Time');
            s = len{j,1};
            len{j} = s;
            beginTime{j} = beginTime{j,1};
            %l = length(s)
        end
    end

    [accMatS{i}] = accMatProcessing(beginTime,len,startTime, stopTime, No_snap, dT);
end

disp(' computing the acc');
accMat = cell(1,No_snap);%%No_snap is the times of snapshots.
% distanceMat = cell(1,No_snap);
% delayMat = cell(1,No_snap);
% accTmp=zeros(No_leo + No_meo + No_geo + No_fac,No_leo + No_meo + No_geo + No_fac);
% disTmp=zeros(No_leo + No_meo + No_geo + No_fac,No_leo + No_meo + No_geo + No_fac);
% delTmp = zeros(No_leo + No_meo + No_geo + No_fac,No_leo + No_meo + No_geo + No_fac);
% %accTmp=accTmp-1;
% start_snap=1;
% 
% % only for the link between meo and geo
% for i = 1:No_snap
%     for j=1:No_link
%         num=num_link(j); %#ok<ST2NM>
%         
% %         meo=floor(num/10)-100;%%%100 is the start ID(no-included) of numbering MEO
% %         static_node=mod(num,10);
% %         if(static_node<50)
% %             geo=static_node;
% %         else geo=static_node-50 +No_geo;%%facitivity
% %         end
% %         accTmp(meo,geo) = accMatS{j}(i); %%% the connecitvity of no-th link at the index-th time.      
%         obj1=floor(num/10000);%%%obj1 is the No of the front(or left?) object
%         obj2=mod(num,10000);%obj2 is the No of the behind(or right?) object
%         
%         %we should make the data in the order of "accTmp"
%         
%         if(obj1 > 5000)                  %obj1 is a leo
%             obj1 = obj1 -5000;
%         elseif(obj1 > 100 && obj1 < 5000)%obj1 is a meo
%             obj1 = obj1 -100 + No_leo;
%         elseif(obj1 > 0 && obj1 < 50)   %obj1 is a geo
%              obj1 = obj1 + No_leo + No_meo;
%         else                             %obj1 is a fac
%              obj1 = obj1 - 50 + No_leo + No_meo + No_geo;
%         end
%         
%         if(obj2 > 5000)                  %obj2 is a leo
%             obj2 = obj2 -5000;
%         elseif(obj2 > 100 && obj2 < 5000)%obj2 is a meo
%             obj2 = obj2 -100 + No_leo;
%         elseif(obj2 > 0 && obj2 < 50)   %obj2 is a geo
%              obj2 = obj2 + No_leo + No_meo;
%         else                             %obj2 is a fac
%              obj2 = obj2 - 50 + No_leo + No_meo + No_geo;
%         end
%         accTmp(obj1,obj2) = accMatS{j}(i); %%% the connecitvity of no-th link at the index-th time.      
%         accTmp(obj2,obj1) = accMatS{j}(i);
%         %disTmp(obj1,obj2) = distance{j}(i);
%         %disTmp(obj2,obj1) = distance{j}(i);
%         %delTmp(obj1,obj2) = delay{j}(i);
%         %delTmp(obj2,obj1) = delay{j}(i);
%         
%     end
%     accMat{i} = accTmp;
%     %distanceMat{i} = disTmp;
%     %delayMat{i} = delTmp;
% end
% %save('satData.mat', 'accMat');
end

