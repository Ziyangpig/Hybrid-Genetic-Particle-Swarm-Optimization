function newbest=n_search_num(particle,alpha,D,SCF,M)
%  只对小交车比例优化
C0=20;C1=2;C=1860;
B_num=particle(1,30);
Cbest=C0*sum(particle,'all')+C1*sum(particle.*D,'all');
Sbest=cons_service(particle,SCF,C);% 越小越好，0则全部满足
for ni=max(1,B_num-2):min(B_num+2,M)
    for n=1:alpha
        new_particle=zeros(30,30);
        %大交路
        new_particle(1,30)=ni;
        % 找到原来小交路的站点
        [px,py]=find(particle);
        p=[px,py];
        p(all(p==[1,30],2),:)=[];
        %将对应小交路站点赋新的列车数量
        new_particle(p(:,1),p(:,2))=n*ni;
        % 计算适应度  
        Cnew=C0*sum(new_particle,'all')+C1*sum(new_particle.*D,'all');
        Snew=cons_service(new_particle,SCF,C);
        if Cnew<=Cbest && Snew<=Sbest
            newbest=new_particle;
        elseif Cnew<=Cbest || Snew<=Sbest
            if rand()>0.5
                newbest=new_particle;
            end
        end
    end
end
end

