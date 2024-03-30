nTrains=6;
nStations=5;
js=3;
maxtol=3;
CAP=10;
N=[5,8,13,10,7];
a=[0,1,1,0,1,1];
tol=3;
for i = 1:nTrains
	if a(i) == 0
		r(i,1) = CAP;
	else
		r(i,1:js) = CAP;
	end
end
for j = 1:nStations
	for k = 1:10
		d(j,k,maxtol) = N(j);
	end
	for l = 1:maxtol-1
		d(j,1,l) = 0;
	end
end

for j = 1:nStations
	for k = 1:60
		for l = 1:tol
			if l == 1
				serviced_ij = 0;
                for i = 1: nTrains
					serviced_ij = serviced_ij + r(i,j);
				end 
				s(j,k,l) = min(serviced_ij,d(j,k,l));
			else
				serviced_ij = 0;
                for i = 1: nTrains
					serviced_ij = serviced_ij + r(i,j);
				end 
				s(j,k,l) = min(serviced_ij-sum(s(j,k,1:l-1)),d(j,k,l));
            end
            if l>1
                d(j,k+1,l-1) = d(j,k,l)-s(j,k,l);
            end
		end
	end
	for i = 1:nTrains
		
		r(i,j+1)=r(i,j);
    end
end
