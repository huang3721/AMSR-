% time operation ʱ�����
function [tname2,t1h] = time_add(tname1,intervalh)
t1vec = zeros(1,6);
t1vec(1) = str2num(tname1(1:4));%��� 2010
t1vec(2) = str2num(tname1(5:6));%�·� 01
t1vec(3) = str2num(tname1(7:8));%���� 01
t1h = t1vec(3);
t1vec(3) = t1vec(3)+intervalh;%������������
%t1vec(5) = t1vec(5)+intervalm;
t2_time = datestr(t1vec,30); %����20200103T000000
t2_time = strrep(t2_time,'T','');%ȥ�� T
t2_time = t2_time(1:length(t2_time)-6);% ���±�Ϊ'20200103'
tname2 = t2_time;
% len = length(tvec1);
% tvec2 = zeros(1,len);

