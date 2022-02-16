%% 本代码重新计算了防御结果
%本代码将会对之前完成的H做一个简化，并且能够够好地完成
%原理： 电纳矩阵B=A^t*D*A ,A为输电线-节点连接矩阵，为[1,-1,0]组合 
% 输电线-节点转移因子矩阵S=DA, f=Sx,p=Bx,此处为了方便计入参考节点
clear
clc
a=case14;
%% 提取数据
bus=a.bus;
branch=a.branch;
name=a.bus_name;
gen=a.gen;
%% 
nb=size(bus,1);                            % size(A,n) n=1返回行数，n=2返回列数，nb为节点数（nember of bus)
nl=size(branch,1);                         % nl 线路数
A=zeros(nl,nb);                            % a(ki) 为tk从i出发为1，从i结束为-1，其余为0
for i=1:nl
    A(i,branch(i,1))=1;
    A(i,branch(i,2))=-1;
end
A(:,1)=[];
X=zeros(nl,nl);        %输电线路电纳值对角矩阵
for i=1:nl 
    X(i,i)=1/branch(i,4);                  %-bij=1/xij 
end
B=A'*X*A;               %此时得到可逆对称的电纳矩阵
S=X*A;                  %线路测量矩阵
H=[B;S;] ;            %全量测矩阵
%% 全量测矩阵就此得到，此时注意部分量测是全量测矩阵的某些行组成

%% 开始计算所有的，先计算真值角度
Pd=bus(2:14,3)/100;
Pg=zeros(14,1);
Pg(gen(:,1))=gen(:,2)/100; %用来标注发电机的位置,去除参考节点
Pg(1)=[];
P=Pg-Pd;
theta=(B^-1*P);  %真值
z_true=H*theta;
W=eye(size(H,1))*1000;
%% 攻击
k=1;
for rate=0.95:-0.05:0.5
ok(k) = attackok( H,z_true,rate );
k=k+1;
end
zuobiaox=0.95:-0.05:0.5;
figure
plot(zuobiaox,ok,'o','LineWidth',2)
hold on;
plot(zuobiaox,ok,'LineWidth',2)
set(gca,'XDir','rev');  %横坐标反方向
title('10000次中成功攻击次数')
xlabel('成功攻击到量表的概率')

