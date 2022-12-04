function PlotSolution(tour,model)

    x = model.x;
    y = model.y;
    tour = [tour tour(1)];

    plot(x(tour),y(tour),...
        'b-s','LineWidth',2,...
        'MarkerSize',12,...
        'MarkerFaceColor','y')

end