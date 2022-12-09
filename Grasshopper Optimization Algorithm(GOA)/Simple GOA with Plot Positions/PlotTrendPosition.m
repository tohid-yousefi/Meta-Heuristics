function PlotTrendPosition(pop,it,Data)

    P = cat(1,pop.Position);
    x = P(:,1);
    y = P(:,2);

    %% Show Results
    figure(1)
    pcolor(Data.x1,Data.x2,Data.fx)
    hold on
    plot(x,y,"o","MarkerFaceColor",[1,1,1]);
    xlabel("x1")
    ylabel("x2")
    title(["Iteration: ", num2str(it)])

end