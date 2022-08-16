P=4;
N=4;
m_top=1;
k=1.994426816;%const
m_bottom=N/P;
% temp=(24/(P-m_top/m_bottom));
temp=23.934444/15
% temp=24/15
% temp=(24/(m_top/m_bottoms));
altitude=(((temp^2)/k)^(1/3)-1)*6371;   
disp(altitude)
                