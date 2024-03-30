function y = cons_service(particle,SCF,C)
%  计算对服务约束的总违反量，全部满足则为0
seg=size(SCF,1);
N=size(particle,1);
overcap=zeros(1,seg);
for k = 1:seg
    temp=sum(particle(1:k,k+1:N),'all')*C-SCF(k);
    if temp>=0
        overcap(k)=0;
    else
        overcap(k)=-temp;
    end
end
y=sum(overcap);
end

