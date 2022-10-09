function [z, Out] = MyCost(x,model)
    
    global NFE;
    if isempty(NFE)
        NFE = 0;
    end
    NFE = NFE + 1;
    
    N = model.N;
    D = model.D;
    [~, Tour] = sort(x);
    
    L = 0;
    for k=1:N
        i = Tour(k);
        if k<N
            j = Tour(k+1);
        else
            j = Tour(1);
        end

        L = L + D(i,j);
    end

    z = L;
    Out.Tour = Tour;
    Out.L = L;


end