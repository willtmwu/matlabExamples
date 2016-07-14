function M=getmatind(m,x,y)

M=zeros(size(x));
for i=1:size(x,1)
    for j=1:size(x,2)
        %M(i,j)=m(x(i,j),y(i,j));
        %M(i,j)=m(x(j,i),y(j,i));
        M(i,j)=m(y(i,j),x(i,j)); 
    end
end
