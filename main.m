%%
clc;
clear;
close all;
%% 数据导入及参数设置
filename1="C:\Users\lenovo\Desktop\23mathorcup\数据\处理 车站数据.xlsx";
filename2="C:\Users\lenovo\Desktop\23mathorcup\B题\附件\附件2：区间运行时间.xlsx";
filename3="C:\Users\lenovo\Desktop\23mathorcup\B题\附件\附件4：断面客流数据.xlsx";
C=1860;LN=3;UN=24;
%导入数据文件
opts1 = detectImportOptions(filename1,'range',[2,2]);
isturn=readmatrix(filename1,opts1);

opts2 = detectImportOptions(filename2,'range',[2,3]);
d=readmatrix(filename2,opts2);

opts3 = detectImportOptions(filename3,'range',[2,2]);
SCF=readmatrix(filename3,opts3);

% 算法参数
ger=50;
popsize=10000;
c1max=0.8;c2max=0.8;
c1min=0.5;c2min=0.5;
% 模型参数
C0=20;C1=1;
N=size(isturn,1);% 车站数量
M=30; %
alpha=4; % 发车模式参数
Inf=10^5;
D=zeros(N,N);
index_seq=find(isturn==1); % 可折返车站索引
%%
for ii=1:N
    D(ii,1:ii)=0;
    D(ii,ii+1:N)=cumsum(d(ii:end));
end
%% intial pop
pop=zeros(N,N,popsize);
pop(1,N,:)=randi(M,1,popsize);
k=1;
while k<=popsize
    for ii=2:N
        if ~isturn(ii)
            continue;
        end
        for jj=ii+1:N % 单向发车
            if ~isturn(jj)
                continue;
            end
            if rand>0.5
                pop(ii,jj,k)=pop(1,N,k)*randi(alpha);
            else
                pop(ii,jj,k)=round(pop(1,N,k)/randi(alpha));
            end
            if rand>0.5
                temp=pop(1,N,k)*randi(alpha);
            else
                temp=round(pop(1,N,k)/randi(alpha));
            end            
            i2=randi(14);j2=randi(14);
            while (index_seq(i2)==ii && index_seq(j2)==jj) | (index_seq(i2)==1 && index_seq(j2)==30)
                i2=randi(14);
                while j2==i2
                    j2=randi(14);
                end
            end
            pop(index_seq(i2),index_seq(j2),k)=temp; 
            k=k+1;
            if k==popsize+1
                break;
            end
        end
        if k==popsize+1
            break;
        end
    end
end

%% 检验种群状态
for k=1:popsize 
    flag(k)=length(find(pop(:,:,k)))==3;
end
sum(flag)
%种群 小交路区间约束 检验
for k=1:popsize 
    flag(k)=cons_range(pop(:,:,k));
end
sum(flag)
% 种群 客流量约束 检验
over_cons=zeros(1,popsize);
for k=1:popsize 
    if cons_range(pop(:,:,k))
        over_cons(k)=cons_service(pop(:,:,k),SCF,C);
    else
        over_cons(k)=Inf;
    end
end
sum(over_cons==0)
%% 替换下一部分
I=(over_cons==0);
for k=1:popsize 
    I2(k)=cons_range(pop(:,:,k));
end
for k = 1:popsize
    obj(k)=C0*sum(pop(:,:,k),'all')+C1*sum(pop(:,:,k).*D,'all');
end
%
I3=I & I2;
I_zbest=find(I3==1,1);
fitness_zbest=obj(I_zbest);
for k=1:popsize
    if I3(k)==1 
        if obj(k)< fitness_zbest
            I_zbest=k;
            fitness_zbest=obj(k);
        end
    end
end
zbest=pop(:,:,I_zbest);
[x,y,nbest]=find(zbest);
%% 计算初始种群适应度值
fitness_gbest=fitness_3(pop,over_cons,D);
fitness_pop=fitness_gbest;
[fitness_zbest,I_zbest]=min(fitness_gbest);
zbest=pop(:,:,I_zbest);
[x,y,nbest]=find(zbest);
%% 迭代  
gbest=pop;
iter = 1;                        %迭代次数
record = zeros(ger, 1);          % 记录器
while iter <= ger
    fmin=min(fitness_gbest);fmax=max(fitness_gbest(fitness_gbest~=Inf));
    for k=1:popsize
       % c2社会学习 c1个体学习 
       if fitness_pop(k)~=Inf
           c1=c1max-(c1max-c1min)*((fitness_pop(k)-fmin)/(fmax-fmin));
           c2=c2min+(c2max-c2min)*((fitness_pop(k)-fmin)/(fmax-fmin));
       else
           c1=c1min;
           c2=c2max;
       end
       pop(:,:,k)=learn(pop(:,:,k),c1,zbest,index_seq,alpha);       %    与种群历史最优进行交叉
       pop(:,:,k)=learn(pop(:,:,k),c2,gbest(:,:,k),index_seq,alpha);   % 与个体历史最优进行交叉
       % 邻域搜索
       pop(:,:,k)=n_search_node(pop(:,:,k),D,index_seq);
       pop(:,:,k)=n_search_num(pop(:,:,k),alpha,D,SCF,M);
    end
    for k=1:popsize 
        if cons_range(pop(:,:,k))
            over_cons(k)=cons_service(pop(:,:,k),SCF,C);
        else
            over_cons(k)=Inf;
        end
    end
    % 计算fitness
    fitness_pop = fitness(pop,over_cons,D);                      % 当前个体的适应度   
    % 新个体最佳
    I_update=fitness_pop-fitness_gbest<0;
    fitness_gbest(I_update)=fitness_pop(I_update);
    gbest(:,:,I_update)=pop(:,:,I_update);
    %   新种群最佳
    if any(fitness_zbest-fitness_pop>0)
        [fitness_zbest,I_zbest]=max(fitness_zbest-fitness_pop);
        zbest=pop(:,:,I_zbest);
    end

    record(iter) = fitness_zbest;
    
    iter = iter+1;
end
%%
[x,y,nbest]=find(zbest);
cons_service(zbest,SCF,C)
plot((1:ger)',record)