N=16;
m=1;
k=1;%即共k+1层
inclination=70;%倾角
cycle=24*3600/(N-m);%一圈秒数
dtr=pi/180;
i=0;
omiga=pi/(3600*12);
weidu={}
for kk=0:k
    weidu_k=[0];
    delt=pi/((N-m)*N^kk);%他的含义是每个最小区块的经度差
    tt=delt;
    for t=1:cycle/4
        temp=atan(cos(inclination*dtr)*tan((N-m)*omiga*t))-omiga*t;
        if temp>tt
            w=asin(sin(inclination*dtr)*sin((N-m)*omiga*t));
            weidu_k=[w/dtr,weidu_k,-w/dtr];
            tt=tt+delt;
        end
    end
    weidu_k=[inclination,weidu_k,-inclination];
    weidu{kk+1}=weidu_k
end

w=45;
j=130;
k=1;
for kk=0:k
    delt=2*pi/((N-m)*N^kk);%他的含义是每个最小区块的经度差
    lie=mod(jingdu,delt);
    for i=1:length(weidu{kk+1})
        if w>weidu{kk+1}(i)
            disp(i)
            break
        end
    end
end
    


