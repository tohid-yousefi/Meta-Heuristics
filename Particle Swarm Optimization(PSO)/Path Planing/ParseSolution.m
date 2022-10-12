function sol2 = ParseSolution(sol1,model)

    x  =sol1.x;
    y = sol1.y;

    xs = model.xs;
    ys = model.ys;
    xt = model.xt;
    yt = model.yt;
    xc = model.xc;
    yc = model.yc;
    r = model.r;

    XS = [xs x xt];                  % XS = XSpline, xs = xstart, xt = xtarget
    YS = [ys y yt];                  % YS = YSpline, ys = ystart, yt = ytarget

    k = numel(XS);
    TS = linspace(0,1,k);

    tt = linspace(0,1,100);
    xx = spline(TS,XS,tt);
    yy = spline(TS,YS,tt);

    dx = diff(xx);
    dy = diff(yy);
    L = sum(sqrt(dx.^2 + dy.^2));

    d = sqrt((xx-xc).^2 + (yy-yc).^2);
    violation = max(1-d/r,0);
    MeanViolation = mean(violation);

    sol2.TS = TS;
    sol2.XS = XS;
    sol2.YS = YS;
    sol2.tt = tt;
    sol2.xx = xx;
    sol2.yy = yy;
    sol2.dx = dx;
    sol2.dy = dy;
    sol2.L = L;
    sol2.MeanViolation = MeanViolation;
    sol2.IsFeasible = (MeanViolation==0);

    % Plot Results
%     figure;
%     plot(xx,yy)
%     hold on
%     plot(XS,YS,'ro')
%     xlabel('x')
%     ylabel('y')
% 
%     figure;
%     plot(tt,xx)
%     hold on
%     plot(TS,XS,'ro')
%     xlabel('t')
%     ylabel('x')
% 
%     figure;
%     plot(tt,yy)
%     hold on
%     plot(TS,YS,'ro')
%     xlabel('t')
%     ylabel('y')

end