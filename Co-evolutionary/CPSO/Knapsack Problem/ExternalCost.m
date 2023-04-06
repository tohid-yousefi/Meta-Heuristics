function [z, out] = ExternalCost(alpha, params, model)

    out = RunInternalPSO(alpha, params, model);
    
    MeanFeasibleCost = out.MeanFeasibleCost;
    nFeasible = out.nFeasible;
    
    beta = 1;
    z = MeanFeasibleCost - beta * nFeasible;

    out.z = z;
    
end