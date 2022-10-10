function PlotSolution(a,model)

    x = model.x;
    y = model.y;
    fhat = model.fhat;

    xmin = min(x);
    xmax = max(x);

    dx = xmax - xmin;
    xmin = xmin-0.1*dx;
    xmax = xmax+0.1*dx;

    xx = linspace(xmin,xmax,100);
    yy = zeros(size(xx));

    for i=1:numel(xx)
        yy(i) = fhat(xx(i),a);
    end

    plot(x,y,'ro','MarkerSize',10,'MarkerFaceColor','y')
    hold on
    plot(xx,yy,'k','LineWidth',2)
    legend('Train Data','Fitted Curve')
    xlabel('x')
    ylabel('y')
    hold off
    grid on
    

end