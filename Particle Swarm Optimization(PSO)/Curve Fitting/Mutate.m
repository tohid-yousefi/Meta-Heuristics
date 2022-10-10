function xnew = Mutate(x,mu,VarMin,VarMax)

    nVar = numel(x);
    nmu = ceil(mu*nVar);
    j = randsample(nVar,nmu);

    sigma = 0.1*(VarMax - VarMin);
    xnew = x;
    xnew(j) = x(j)+sigma*randn(size(j));

    xnew = max(xnew,VarMin);
    xnew = min(xnew,VarMax);

end