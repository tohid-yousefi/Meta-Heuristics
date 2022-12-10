function Data = PlotFunction(name)

switch name
    case 'Sphere'
        x1 = -10:0.1:10;
        x2 = x1;
        [x1,x2] = meshgrid(x1,x2);
        fx = x1.^2 + x2.^2;
    case 'Rastrigin'
        x1 = -5.12:0.1:5.12;
        x2 = x1;
        [x1,x2] = meshgrid(x1,x2);
        fx = 10*2 + (x1.^2 - 10*cos(2*pi*x1)) + (x2.^2 - 10*cos(2*pi*x2));
    case 'Rosenbrock'
        x1 = -5:0.1:10;
        x2 = x1;
        [x1,x2] = meshgrid(x1,x2);
        fx = 100*(x2-x1.^2).^2 + (x1-1).^2;
end



Data.x1 = x1;
Data.x2 = x2;
Data.fx = fx;
figure,surf(x1,x2,fx)
xlabel('x1')
ylabel('x2')
zlabel('f(x1,x2)')
title([name,' Function'])
end