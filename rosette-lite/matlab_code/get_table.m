N=16;
m=2;
k=1;%即共k+1层
inclination=70;%倾角
cycle=24*3600/(N-m)%一圈秒数
dtr=pi/180;
i=0;
omiga=pi/(3600*12);
omiga2=2*pi/cycle;
alpha={}
gamma={}
for kk=0:k
    alpha_k=[];
    gamma_k=[];
    delt=pi/((N-m)*N^kk);%他的含义是每个最小区块的经度差
    tt=delt;
    pianyi=3600*12/((N-m)*N^kk);
    for t=1:cycle/4
        temp=atan(cos(inclination*dtr)*tan((N-m)*omiga*t))-omiga*t;
        if temp>tt
%             disp (mod(-t,(3600*24))*omiga);
            temp2=asin(sin(inclination*dtr)*sin((N-m)*omiga*t));
            alpha_k=[mod(t+pianyi,(3600*24))*omiga,alpha_k,mod(-t+pianyi,(3600*24))*omiga];
            gamma_k=[t*omiga2,gamma_k,2*pi-t*omiga2];
            tt=tt+delt;
        end
    end
    alpha_k=[mod(cycle/4,(3600*24))*omiga,alpha_k,mod(-cycle/4,(3600*24))*omiga];
    alpha{kk+1}=alpha_k;
    gamma_k=[pi/2,gamma_k,3*pi/2];
    gamma{kk+1}=gamma_k;
end
alpha
gamma

