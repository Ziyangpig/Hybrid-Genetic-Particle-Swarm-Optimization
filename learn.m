function new=learn(particle,c,best,index_seq,alpha)
%  如果线路大于2，find处需要改
new=zeros(30,30);
% i j
[px,py]=find(particle);
[bx,by]=find(best);
p=[px,py];
b=[bx,by];
% 去除大交路，前提是X(1，30)一定是0
p(all(p==[1,30],2),:)=[];
b(all(b==[1,30],2),:)=[];
% 站点学习  可行解
ipx=find(index_seq==p(:,1));
ipy=find(index_seq==p(:,2));
ibx=find(index_seq==b(:,1));
iby=find(index_seq==b(:,2));
nix=ipx+round(c*rand()*(ibx-ipx));
niy=ipy+round(c*rand()*(iby-ipy));
if nix<1
    nix=1;
elseif nix>length(index_seq)
    nix=length(index_seq);
end
if niy<1  
    niy=1;
elseif niy>length(index_seq)
    niy=length(index_seq);
end
if niy==nix
    if niy<index_seq
        niy=nix+1;
    else
        nix=niy-1;
    end
end
nx=index_seq(nix);
ny=index_seq(niy);
% 发车数量学习
new(1,30)=particle(1,30)+round(c*rand()*(best(1,30)-particle(1,30)));
new(nx,ny)=new(1,30)*randi(alpha);
end

