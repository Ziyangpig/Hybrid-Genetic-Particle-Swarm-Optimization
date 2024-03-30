function y = cons_range(particle)
%  输入paritcle 一个个体，N*N
%  
LN=3;
UN=24;
[nodex,nodey]=find(particle);
node=[nodex,nodey];
% 去除大交路，前提是X1，30一定是0
node(all(node==[1,30],2),:)=[];
% 小交路区间约束 
y=all(node(:,2)-node(:,1)<=UN) && all(node(:,2)-node(:,1)>=LN);
end

