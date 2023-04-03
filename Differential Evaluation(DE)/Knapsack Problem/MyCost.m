function [z, sol] = MyCost(xhat, model)
    
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

    Violation = max(0, WA/Wmax-1);
    
%     alpha=100;
%     z = VB+alpha*Violation;
    beta = 10;
    z = VB*(1+beta*Violation);

    sol.x = x;
    sol.nA = nA;
    sol.nB = nB;
    sol.VA = VA;
    sol.VB = VB;
    sol.WA = WA;
    sol.WB = WB;
    sol.Violation = Violation;
    sol.IsFeasible = (Violation==0);
    sol.z = z;


end