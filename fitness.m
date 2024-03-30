function fitness_pop = fitness(pop,over_cons,D)
%UNTITLED2 此处显示有关此函数的摘要
C0=20;C1=1;
Inf=10^5;
popsize=size(pop,3);
obj_num=zeros(1,popsize);
obj_d=zeros(1,popsize);
for k = 1:popsize
    if cons_range(pop(:,:,k))
        obj_num(k)=C0*sum(pop(:,:,k),'all');
        obj_d(k)=C1*sum(pop(:,:,k).*D,'all');
    else
        obj_num(k)=Inf;
        obj_d(k)=Inf;
    end
end
% 归一化目标函数 
obj_num_mean=mean(obj_num(obj_num~=Inf));
obj_d_mean=mean(obj_d(obj_d~=Inf));
cons_mean=mean(over_cons(over_cons~=Inf));
% 自适应无参目标函数惩罚因子
nfeasible=sum(over_cons==0);
fitness_pop=obj_num/obj_num_mean+obj_d/obj_d_mean+(1-nfeasible/popsize)*over_cons/cons_mean;
fitness_pop(obj_num==Inf)=Inf;
end

