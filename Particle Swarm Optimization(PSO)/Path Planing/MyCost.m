function [z, Out] = MyCost(sol1,model)
    
    global NFE;
    if isempty(NFE)
        NFE = 0;
    end
    NFE = NFE + 1;

    Out = ParseSolution(sol1,model);
    
    beta = 10;
    z = Out.L*(1+beta*Out.MeanViolation);

end