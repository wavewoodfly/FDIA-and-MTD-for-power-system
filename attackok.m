function ok = attackok( H,z_true,rate )
%���������ڼ��㹥���ɹ��ʣ������빥��������
ok=0; %���ع�������
W=eye(size(H,1))*1000;
for i=1:10000
    c=zeros(13,1); %��������
    c(13)=1; %��������
    c(1)=1; %��������
    a=H*c;
    for cnt=14:33
        if rand>rate
            a(cnt)=0;
        end
    end
    z_mes=z_true+randn(size(H,1),1)*sqrt(0.001);
    z=z_mes+a;
    x1=inv(H'*W*H)*H'*W*(z);
    r=norm(z-H*x1);
    if r<0.5405
        ok=ok+1;
    end
    
end

end

