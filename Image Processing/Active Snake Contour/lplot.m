function lplot(x,y,c)

for i=1:(length(x)-1)
    line([x(i) x(i+1)]',[y(i) y(i+1)]','color',c)
end
line([x(length(x)) x(1)],[y(length(x)) y(1)],'color',c)