%% ���������¼����˷������
%�����뽫���֮ǰ��ɵ�H��һ���򻯣������ܹ����õ����
%ԭ�� ���ɾ���B=A^t*D*A ,AΪ�����-�ڵ����Ӿ���Ϊ[1,-1,0]��� 
% �����-�ڵ�ת�����Ӿ���S=DA, f=Sx,p=Bx,�˴�Ϊ�˷������ο��ڵ�
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
H=[B;S;] ;            %ȫ�������
%% ȫ�������ʹ˵õ�����ʱע�ⲿ��������ȫ��������ĳЩ�����

%% ��ʼ�������еģ��ȼ�����ֵ�Ƕ�
Pd=bus(2:14,3)/100;
Pg=zeros(14,1);
Pg(gen(:,1))=gen(:,2)/100; %������ע�������λ��,ȥ���ο��ڵ�
Pg(1)=[];
P=Pg-Pd;
theta=(B^-1*P);  %��ֵ
z_true=H*theta;
W=eye(size(H,1))*1000;
%% ����
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
set(gca,'XDir','rev');  %�����귴����
title('10000���гɹ���������')
xlabel('�ɹ�����������ĸ���')

