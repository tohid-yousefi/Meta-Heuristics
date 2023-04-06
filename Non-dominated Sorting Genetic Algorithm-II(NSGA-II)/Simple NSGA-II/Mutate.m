function y=Mutate(x,mu,sigma)

    nVar=numel(x);
    
    nMu=ceil(mu*nVar);

    j=randsample(nVar,nMu);
    
    y=x;
    
    y(j)=x(j)+sigma*randn(size(j));

end