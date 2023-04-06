function [z, sol] = InternalCost(xhat, model, alpha)
    
    n = model.n;
    V = model.V;
    W = model.W;
    Wmax = model.Wmax;

    x = ParseSolution(xhat);

    nA = sum(x);
    nB = n - nA;
    
    % A is the ones we were able to take and B is the ones we couldn't take
    VA = sum(V.*x);
    VB = sum(V.*(1-x));

    WA = sum(W.*x);
    WB = sum(W.*(1-x));

    SumViol = max(0, WA/Wmax-1);
    NumViol = double(SumViol>0);

    %z = VB+(alpha(1)*SumViol+alpha(2)*NumViol)*1000;
    z = (1000+VB) * (1+alpha*SumViol)-1000;

    sol.x = x;
    sol.nA = nA;
    sol.nB = nB;
    sol.VA = VA;
    sol.VB = VB;
    sol.WA = WA;
    sol.WB = WB;
    sol.SumViol = SumViol;
    sol.NumViol = NumViol;
    sol.IsFeasible = (NumViol==0);
    sol.z = z;

end