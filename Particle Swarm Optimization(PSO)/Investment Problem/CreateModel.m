function model=CreateModel()

    P{1} = @(I) 2*I;
    P{2} = @(I) (2.5*(I-20)).*(I>=20);
    P{3} = @(I) 120*min(I/10,1);
    P{4} = @(I) exp(0.03*I)-1;
    
    n = numel(P);
    Imax = 120;
    
    model.n = n;
    model.P = P;
    model.Imax = Imax;

end