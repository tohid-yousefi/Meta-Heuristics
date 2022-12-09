function Data = PlotFunction(Params)

    %% Definition
    lb = Params.lb;
    ub = Params.ub;
    x1 = lb:0.1:ub;
    x2 = x1;
    [x1,x2] = meshgrid(x1,x2);
    fx = x1.^2 + x2.^2;
    
    %% Show Results
    % figure;
    % surf(x1,x2,fx)
    % xlabel("x1")
    % ylabel("x2")
    % zlabel("(f(x1,x2)")
    % title("Sphere Function")
    % figure(1);
    % pcolor(x1,x2,fx)
    % hold on

    Data.x1 = x1;
    Data.x2 = x2;
    Data.fx = fx;

end