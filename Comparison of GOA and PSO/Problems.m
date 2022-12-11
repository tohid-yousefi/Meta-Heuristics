function P = Problems(name)

nVar = 15;
CostFunction = @(x)eval(['TestFunction.',name,'(x)']);
switch name
    case 'Sphere'
        VarMin = -100;
        VarMax =  100;
    case 'Rastrigin'
        VarMin = -5.12;
        VarMax =  5.12;
    case 'Rosenbrock'
        VarMin = -5;
        VarMax = 10;
end


P.nVar = nVar;
P.VarMin = VarMin;
P.VarMax = VarMax;
P.CostFunction = CostFunction;

end