function PlotSolution(sol, model)

     n = model.n;
     P = model.P;
     Imax = model.Imax;
     I = sol.I;
     p = sol.p;
     
     II = 0:Imax;
     Colors = hsv(n);

     for i=1:n
        plot(II, P{i}(II), 'Color',Colors(i,:), 'LineWidth',2);
        hold on
     end

     for i=1:n
        plot([I(i) I(i)],[p(i) 0],':', 'Color',Colors(i, :));
        plot([I(i) 0],[p(i) p(i)],':', 'Color',Colors(i, :))
        plot(I(i), p(i), 'ko', 'MarkerFaceColor',Colors(i, :), 'MarkerSize',12);

     end

     hold off

end