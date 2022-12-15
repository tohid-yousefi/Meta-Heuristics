function pop = SortPopulation(pop)
    Costs = [pop.Cost];
    [~, SortOrder] = sort(Costs);
    pop = pop(SortOrder);
end