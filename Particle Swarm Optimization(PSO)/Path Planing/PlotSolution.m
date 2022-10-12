function PlotSolution(Out,model)

    xs = model.xs;
    ys = model.ys;
    xt = model.xt;
    yt = model.yt;
    xc = model.xc;
    yc = model.yc;
    r = model.r;
    
    XS = Out.XS;
    YS = Out.YS;
    xx = Out.xx;
    yy = Out.yy;
    
    theta = linspace(0,2*pi,100);
    fill(xc+r*cos(theta),yc+r*sin(theta),'m')
    hold on
    plot(xx,yy,'k','LineWidth',2)
    plot(XS,YS,'ro')
    plot(xs,ys,'bs','MarkerSize',12,'MarkerFaceColor','y')
    plot(xt,yt,'kp','MarkerSize',16,'MarkerFaceColor','g')
    hold off
    grid on
    axis equal

end