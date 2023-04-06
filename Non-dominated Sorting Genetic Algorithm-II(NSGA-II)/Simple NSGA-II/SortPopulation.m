function [pop F]=SortPopulation(pop)

    % Sort Based on Crowding Distance
    [~, CDSO]=sort([pop.CrowdingDistance],'descend');
    pop=pop(CDSO);
    
    % Sort Based on Rank
    [~, RSO]=sort([pop.Rank]);
    pop=pop(RSO);
    
    % Update Fronts
    Ranks=[pop.Rank];
    MaxRank=max(Ranks);
    F=cell(MaxRank,1);
    for r=1:MaxRank
        F{r}=find(Ranks==r);
    end

end