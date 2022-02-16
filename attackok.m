function ok = attackok( H,z_true,rate )
%本函数用于计算攻击成功率，需输入攻击覆盖率
ok=0; %记载攻击次数
W=eye(size(H,1))*1000;
for i=1:10000
    c=zeros(13,1); %攻击向量
    c(13)=1; %攻击向量
    c(1)=1; %攻击向量
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

