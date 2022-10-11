function [z, Out] = MyCost(xhat,model)
    
    global NFE;
    if isempty(NFE)
        NFE = 0;
    end
    NFE = NFE + 1;
    
    x = ParseSolution(xhat,model);

    M = model.M;
    v = model.v;
    w = model.w;
    W = model.W;
    
    r = M-x;
    SumVR = sum(v.*r);
    SumVX = sum(v.*x);
    SumWX = sum(w.*x); 

    Violation = max(SumWX/W-1,0);

      % Additive
%     alpha = 1000;
%     z = SumVR+alpha*Violation;
    
    % Multiplicative
    beta = 10;
    z = SumVR*(1+beta*Violation);
    
    Out.x = x;
    Out.r = r;
    Out.SumVR = SumVR;
    Out.SumVX = SumVX;
    Out.SumWX = SumWX;
    Out.Violation = Violation;
    Out.z = z;
    Out.IsFeasible = (Violation == 0);

end