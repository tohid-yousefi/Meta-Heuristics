function [z, sol]=MyCost(xhat, model)
    
    global NFE;

    if isempty(NFE)
        NFE=0;
    end
    NFE=NFE+1;

    n = model.n;
    P = model.P;
    Imax = model.Imax;
    I = Imax*xhat/sum(xhat);

    p = zeros(1, n);
    for i=1:n
        p(i) = P{i} (I(i));
    end

    pTotal = sum(p);

    z=exp(-pTotal);

    sol.I = I;
    sol.p = p;
    sol.pTotal = pTotal;
    sol.z = z;

end