function [ delay ] = Create_delay(position_cbf,position_cbf_low,time, inc)
% Calculate delay between LEOs and facilities
% input:
%   position_cbf: used to connect to STK
%   delay: two-dimensional matrix, delay(i,j) denotes 
    global No_fac  No_leo constellation;
    No_leo=16+256;
    distance = zeros(No_fac+No_leo,No_fac+No_leo);
    delay = zeros(No_fac+No_leo,No_fac+No_leo);
    %calculate the distance and delay between leo and others(include leo)
    leo_plane=16;
    for i=1:256
        cur_leo=i;
        if(mod(cur_leo,leo_plane)==0)
            up_leo=cur_leo-leo_plane+1;
        else
            up_leo=cur_leo+1;
        end
        distance(cur_leo,up_leo) = sqrt((position_cbf_low{cur_leo,1}(1,time) - position_cbf_low{up_leo,1}(1,time))^2 + (position_cbf_low{cur_leo,1}(2,time) - position_cbf_low{up_leo,1}(2,time))^2 + (position_cbf_low{cur_leo,1}(3,time) - position_cbf_low{up_leo,1}(3,time))^2);
        distance(up_leo,cur_leo) = distance(cur_leo,up_leo);
        delay(cur_leo,up_leo) = distance(cur_leo,up_leo) / (3 * 10^5);
        delay(up_leo,cur_leo) = delay(cur_leo,up_leo);
        
        up_leo=mod(cur_leo+leo_plane-1,256)+1;
        temp=strcat(num2str(cur_leo),',',num2str(up_leo));
        disp(temp);
        distance(cur_leo,up_leo) = sqrt((position_cbf_low{cur_leo,1}(1,time) - position_cbf_low{up_leo,1}(1,time))^2 + (position_cbf_low{cur_leo,1}(2,time) - position_cbf_low{up_leo,1}(2,time))^2 + (position_cbf_low{cur_leo,1}(3,time) - position_cbf_low{up_leo,1}(3,time))^2);
        distance(up_leo,cur_leo) = distance(cur_leo,up_leo);
        delay(cur_leo+16,up_leo+16) = distance(cur_leo,up_leo) / (3 * 10^5);
        delay(up_leo+16,cur_leo+16) = delay(cur_leo+16,up_leo+16);
    end
    for i=1:16
        cur_leo=i;
        if(mod(cur_leo,leo_plane)==0)
            up_leo=cur_leo-leo_plane+1;
        else
            up_leo=cur_leo+1;
        end
        distance(cur_leo,up_leo) = sqrt((position_cbf{cur_leo,1}(1,time) - position_cbf{up_leo,1}(1,time))^2 + (position_cbf{cur_leo,1}(2,time) - position_cbf{up_leo,1}(2,time))^2 + (position_cbf{cur_leo,1}(3,time) - position_cbf{up_leo,1}(3,time))^2);
        distance(up_leo,cur_leo) = distance(cur_leo,up_leo);
        delay(cur_leo,up_leo) = distance(cur_leo,up_leo) / (3 * 10^5);
        delay(up_leo,cur_leo) = delay(cur_leo,up_leo);
    end
    for i=1:16
        cur_leo=i;
        for j=17:256+16
            if i==16
                i=0;
            end
            if mod(j,16)==i 
                up_leo=j;
                distance(cur_leo,up_leo) = sqrt((position_cbf{cur_leo,1}(1,time) - position_cbf_low{up_leo-16,1}(1,time))^2 + (position_cbf{cur_leo,1}(2,time) -position_cbf_low{up_leo-16,1}(2,time))^2 + (position_cbf{cur_leo,1}(3,time) - position_cbf_low{up_leo-16,1}(3,time))^2);
                distance(up_leo,cur_leo) = distance(cur_leo,up_leo);
                if distance(up_leo,cur_leo)<sqrt((6371*10^3+878*10^3)^2-(6381*10^3)^2)+sqrt((6371*10^3+10341*10^3)^2-(6381*10^3)^2)
                    delay(cur_leo,up_leo) = distance(cur_leo,up_leo) / (3 * 10^5);
                    delay(up_leo,cur_leo) = delay(cur_leo,up_leo);
                end
            end
        end
    end
    filename = [constellation '\delay\'];
    filename = strcat(filename,num2str(time));
    filename = strcat(filename,'.mat');
    save(filename,'delay') 
end