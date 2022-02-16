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
H=[B;S;-S] ;            %全量测矩阵
%% 开始计算所有的，先计算真值角度
Pd=bus(2:14,3)/100;
Pg=zeros(14,1);
Pg(gen(:,1))=gen(:,2)/100; %用来标注发电机的位置,去除参考节点
Pg(1)=[];
P=Pg-Pd;
theta=(B^-1*P);  %真值
z_true=H*theta;
W=eye(size(H,1))*1000;



attackok1=0;
for i=1:10000
    %% 第一次模拟
    a=case14;
    X2=X;
    c=zeros(13,1); %攻击向量
    c([11,13])=1;
    z_mes=z_true+randn(size(H,1),1)*sqrt(0.001);
    %% 衡量MTD的有效性,此处假设攻击者知道了错误的H矩阵
    %% 构造错误的H矩阵
    for j=1:20
        change=rand*0.4-0.2;
        a.branch(j,4)=a.branch(j,4)*(1+change);
        X2(j,j)=1/a.branch(j,4);                  %-bij=1/xij
    end
    B2=A'*X2*A;               %此时得到错误的
    S2=X2*A;                  %错误的线路测量矩阵
    H2=[B2;S2;-S2] ;            %错误的全量测矩阵
    
    %%
    %% 虚假数据注入攻击验证:
    
    
    za=z_mes+H2*(c);  %现有测量结果
    x2=inv(H'*W*H)*H'*W*(za);  %状态预测后的现有估计值
    res=norm(za-H*x2);  %叠加攻击向量后的残差
    
    if (res<0.5)
        attackok1=attackok1+1;
    end
end

%% 对比
attackok2=0;
for i=1:10000
    %% 第二次模拟
    a=case14;
    X2=X;
    c=randn(13,1); %攻击向量
    z_mes=z_true+randn(size(H,1),1)*sqrt(0.001);
    %% 衡量MTD的有效性,此处假设攻击者知道了错误的H矩阵
    %% 虚假数据注入攻击验证:
   for j=1:10
        change=rand*0.3-0.15;
        a.branch(j,4)=a.branch(j,4)*(1+change);
        X2(j,j)=1/a.branch(j,4);                  %-bij=1/xij
    end
    B2=A'*X2*A;               %此时得到错误的
    S2=X2*A;                  %错误的线路测量矩阵
    H2=[B2;S2;-S2] ;            %错误的全量测矩阵   
    
    za=z_mes+H2*(c);  %现有测量结果
    x2=inv(H'*W*H)*H'*W*(za);  %状态预测后的现有估计值
    res=norm(za-H*x2);  %叠加攻击向量后的残差
    
    if (res<0.6641)
        attackok2=attackok2+1;
    end
end
