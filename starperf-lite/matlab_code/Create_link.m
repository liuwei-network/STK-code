function [link] = Create_link(conid,chain_name,link_color)
    global No_leo cycle No_snap No_fac  tStart tStop dT constellation leo_plane;
    num_link=0;
    for i=0:leo_plane-1
%         for j=1:No_leo/leo_plane
        for j=1:5
            n1=i*No_leo/leo_plane+j
            if j==No_leo/leo_plane
                n2=i*No_leo/leo_plane+1
            else
                n2=n1+1
            end
            num_link=num_link+1;
            link_no_1=strcat(chain_name,num2str(num_link));
            stkNewObj('*/','Chain',link_no_1);
            info_l1=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat',num2str(n1));
            info_l2=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat',num2str(n2));

            rtn = stkExec(conid,info_l1);
            rtn = stkExec(conid,info_l2);
            info_link=strcat(' */Chain/',link_no_1);

            [secData, secName] = stkReport(info_link, 'Time Ordered Access', tStart, tStop, dT);
%             temp1=strcat('Graphics ',info_link,' Animation On ',32,link_color);
            temp1=strcat('Graphics ',info_link,' Animation Off ');
            stkExec(conid,temp1);
            temp1=strcat('Graphics ',info_link,' AnimationLine Off ');
            stkExec(conid,temp1);            
            temp1=strcat('Graphics ',info_link,' Static On ',32,link_color,32,'8');
            stkExec(conid,temp1);
            if i==leo_plane-1
                n3=j
            else
                n3=n1+No_leo/leo_plane
            end
                            num_link=num_link+1;
            link_no_1=strcat(chain_name,num2str(num_link));
            stkNewObj('*/','Chain',link_no_1);
            info_l1=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat',num2str(n1));
            info_l2=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat',num2str(n3));

            rtn = stkExec(conid,info_l1);
            rtn = stkExec(conid,info_l2);
            info_link=strcat(' */Chain/',link_no_1);

            [secData, secName] = stkReport(info_link, 'Time Ordered Access', tStart, tStop, dT);
%             temp1=strcat('Graphics ',info_link,' Animation On ',32,link_color);

            temp1=strcat('Graphics ',info_link,' Animation Off ');
            stkExec(conid,temp1);
            temp1=strcat('Graphics ',info_link,' AnimationLine Off ');
            stkExec(conid,temp1);            
            temp1=strcat('Graphics ',info_link,' Static On ',32,link_color,32,'8');
            stkExec(conid,temp1);
        end
        for j=18:22
            n1=i*No_leo/leo_plane+j
            if j==No_leo/leo_plane
                n2=i*No_leo/leo_plane+1
            else
                n2=n1+1
            end
            num_link=num_link+1;
            link_no_1=strcat(chain_name,num2str(num_link));
            stkNewObj('*/','Chain',link_no_1);
            info_l1=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat',num2str(n1));
            info_l2=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat',num2str(n2));

            rtn = stkExec(conid,info_l1);
            rtn = stkExec(conid,info_l2);
            info_link=strcat(' */Chain/',link_no_1);

            [secData, secName] = stkReport(info_link, 'Time Ordered Access', tStart, tStop, dT);
%             temp1=strcat('Graphics ',info_link,' Animation On ',32,link_color);

            temp1=strcat('Graphics ',info_link,' Animation Off ');
            stkExec(conid,temp1);
            temp1=strcat('Graphics ',info_link,' AnimationLine Off ');
            stkExec(conid,temp1);            
            temp1=strcat('Graphics ',info_link,' Static On ',32,link_color,32,'8');
            stkExec(conid,temp1);

            if i==leo_plane-1
                n3=j
            else
                n3=n1+No_leo/leo_plane
            end
                            num_link=num_link+1;
            link_no_1=strcat(chain_name,num2str(num_link));
            stkNewObj('*/','Chain',link_no_1);
            info_l1=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat',num2str(n1));
            info_l2=strcat('Chains */Chain/',link_no_1,' add */Satellite/Sat',num2str(n3));

            rtn = stkExec(conid,info_l1);
            rtn = stkExec(conid,info_l2);
            info_link=strcat(' */Chain/',link_no_1);

            [secData, secName] = stkReport(info_link, 'Time Ordered Access', tStart, tStop, dT);
%             temp1=strcat('Graphics ',info_link,' Animation On ',32,link_color);

            temp1=strcat('Graphics ',info_link,' Animation Off ');
            stkExec(conid,temp1);
            temp1=strcat('Graphics ',info_link,' AnimationLine Off ');
            stkExec(conid,temp1);            
            temp1=strcat('Graphics ',info_link,' Static On ',32,link_color,32,'8');
            stkExec(conid,temp1);
        end
    end
end

