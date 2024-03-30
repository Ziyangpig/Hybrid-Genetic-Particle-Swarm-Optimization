function new=n_search_node(particle,D,index_seq)
% 此处显示有关此函数的摘要
%   此处显示详细说明
C=1870;
m=length(index_seq);
[px,py]=find(particle);
p=[px,py];
p(all(p==[1,30],2),:)=[];
ipx=find(index_seq==p(:,1));
ipy=find(index_seq==p(:,2));
cnb=D(p(:,1),p(:,2));
snb=(p(:,2)-p(:,1))*C;
for ix = max(1,ipx-2):min(ipx+2,m)
    for iy = max(1,ipy-2):min(ipy+2,m)
        cn=D(index_seq(ix),index_seq(iy));
        sn=(index_seq(iy)-index_seq(ix))*C;
        if cn<=cnb && sn>=snb
            nx=index_seq(ix);
            ny=index_seq(iy);
            cnb=cn;snb=sn;
        elseif cn<=cnb || sn>=snb
            if rand()>0.5
                nx=index_seq(ix);
                ny=index_seq(iy);
                cnb=cn;snb=sn;
            end
        end
    end
end
new=zeros(30,30);
new(1,30)=particle(1,30);
new(nx,ny)=particle(p(:,1),p(:,2));
end

