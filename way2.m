clear
clc
a=case14;
%% ��ȡ����
bus=a.bus;
branch=a.branch;
name=a.bus_name;
gen=a.gen;
%%
nb=size(bus,1);                            % size(A,n) n=1����������n=2����������nbΪ�ڵ�����nember of bus)
nl=size(branch,1);                         % nl ��·��
A=zeros(nl,nb);                            % a(ki) Ϊtk��i����Ϊ1����i����Ϊ-1������Ϊ0
for i=1:nl
    A(i,branch(i,1))=1;
    A(i,branch(i,2))=-1;
end
A(:,1)=[];
X=zeros(nl,nl);        %�����·����ֵ�ԽǾ���
for i=1:nl
    X(i,i)=1/branch(i,4);                  %-bij=1/xij
end
B=A'*X*A;               %��ʱ�õ�����ԳƵĵ��ɾ���
S=X*A;                  %��·��������
H=[B;S;-S] ;            %ȫ�������
%% ��ʼ�������еģ��ȼ�����ֵ�Ƕ�
Pd=bus(2:14,3)/100;
Pg=zeros(14,1);
Pg(gen(:,1))=gen(:,2)/100; %������ע�������λ��,ȥ���ο��ڵ�
Pg(1)=[];
P=Pg-Pd;
theta=(B^-1*P);  %��ֵ
z_true=H*theta;
W=eye(size(H,1))*1000;



attackok1=0;
for i=1:10000
    %% ��һ��ģ��
    a=case14;
    X2=X;
    c=zeros(13,1); %��������
    c([11,13])=1;
    z_mes=z_true+randn(size(H,1),1)*sqrt(0.001);
    %% ����MTD����Ч��,�˴����蹥����֪���˴����H����
    %% ��������H����
    for j=1:20
        change=rand*0.4-0.2;
        a.branch(j,4)=a.branch(j,4)*(1+change);
        X2(j,j)=1/a.branch(j,4);                  %-bij=1/xij
    end
    B2=A'*X2*A;               %��ʱ�õ������
    S2=X2*A;                  %�������·��������
    H2=[B2;S2;-S2] ;            %�����ȫ�������
    
    %%
    %% �������ע�빥����֤:
    
    
    za=z_mes+H2*(c);  %���в������
    x2=inv(H'*W*H)*H'*W*(za);  %״̬Ԥ�������й���ֵ
    res=norm(za-H*x2);  %���ӹ���������Ĳв�
    
    if (res<0.5)
        attackok1=attackok1+1;
    end
end

%% �Ա�
attackok2=0;
for i=1:10000
    %% �ڶ���ģ��
    a=case14;
    X2=X;
    c=randn(13,1); %��������
    z_mes=z_true+randn(size(H,1),1)*sqrt(0.001);
    %% ����MTD����Ч��,�˴����蹥����֪���˴����H����
    %% �������ע�빥����֤:
   for j=1:10
        change=rand*0.3-0.15;
        a.branch(j,4)=a.branch(j,4)*(1+change);
        X2(j,j)=1/a.branch(j,4);                  %-bij=1/xij
    end
    B2=A'*X2*A;               %��ʱ�õ������
    S2=X2*A;                  %�������·��������
    H2=[B2;S2;-S2] ;            %�����ȫ�������   
    
    za=z_mes+H2*(c);  %���в������
    x2=inv(H'*W*H)*H'*W*(za);  %״̬Ԥ�������й���ֵ
    res=norm(za-H*x2);  %���ӹ���������Ĳв�
    
    if (res<0.6641)
        attackok2=attackok2+1;
    end
end
