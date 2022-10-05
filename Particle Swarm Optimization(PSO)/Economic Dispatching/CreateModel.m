function model = CreateModel()

    pmin = [808 853 463 857 716 448 539 673];
    pmax = [2166 2172 1526 2177 2166 1788 2041 1513];
    a0 = [7067 9488 8882 9702 8213 5175 9161 9577];
    a1 = [8 8 8 6 8 5 8 5];
    a2 = [-0.1554 -0.1092 -0.1194 -0.2647 -0.2390 -0.1634 -0.2900 -0.1069]*1e-4;
    PL = 10000;
    N = numel(pmin);
    
    model.N = N;
    model.pmin = pmin;
    model.pmax = pmax;
    model.a0 = a0;
    model.a1 = a1;
    model.a2 = a2;
    model.PL = PL;
    
end