function pop = CalcInvalidCosts(pop)
    
    Costs = [pop.Cost];
    if ~any(isnan(Costs))
        return;
    end

    if all(isnan(Costs))
        Costs(:)=0;
    end

    MaxCost = max(Costs);

    for i=1:numel(pop)
        if isnan(pop(i).Cost)
            pop(i).Cost = MaxCost + pop(i).Out.TotalMeanViol + pop(i).Out.TotalNumViol;
        end
    end

end