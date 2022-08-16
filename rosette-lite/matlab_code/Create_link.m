function [link] = Create_link(conid,chain_name,path,link_color,Sat_name1,Sat_name2)
    global No_leo cycle No_snap No_fac  tStart tStop dT constellation;
    link = readtable(path);
    disp(link);
    num_link=0;
    if strcmp('Chain_High_Low',chain_name)==1
        for i=1:16
            for j=1:256
                if mod(j,16)==i-1 || mod(j,16)==i || mod(j,16)==i+1|| mod(j,16)==i+7 || mod(j,16)==i+8 || mod(j,16)==i+9 
                    num_link=num_link+1;
                    link_no_1=strcat(chain_name,num2str(num_link));
                    stkNewObj('*/','Chain',link_no_1);
                    info_l1=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat_',Sat_name1,num2str(i));
                    info_l2=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat_',Sat_name2,num2str(j));

                    rtn = stkExec(conid,info_l1);
                    rtn = stkExec(conid,info_l2);
                    info_link=strcat(' */Chain/',link_no_1);

                    [secData, secName] = stkReport(info_link, 'Time Ordered Access', tStart, tStop, dT);
                    temp1=strcat('Graphics ',info_link,' Animation On ',32,link_color);
                    stkExec(conid,temp1);
                end              
            end
        end
    else
        for i=2:No_leo
            for j=1:i
                if(link{i,j}==1)
                    num_link=num_link+1;
                    link_no_1=strcat(chain_name,num2str(num_link));
                    stkNewObj('*/','Chain',link_no_1);
                    info_l1=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat_',Sat_name1,num2str(i));
                    info_l2=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat_',Sat_name2,num2str(j-1));

                    rtn = stkExec(conid,info_l1);
                    rtn = stkExec(conid,info_l2);
                    info_link=strcat(' */Chain/',link_no_1);

                    [secData, secName] = stkReport(info_link, 'Time Ordered Access', tStart, tStop, dT);
                    temp1=strcat('Graphics ',info_link,' Animation On ',32,link_color);
                    stkExec(conid,temp1);
                end
            end
        end
    end
end

