function SI = SocialInteraction(GHs,Params)

    i = Params.i;
    lb = Params.lb;
    ub = Params.ub;
    nPop = Params.nPop;
    c = Params.c;

    xi = GHs(i,:);
    GHs(i,:) = [];

    dist = pdist2(xi,GHs);
    %ndist = 2 + 2*(dist/max(dist));
    ndist = 2 + rem(dist,2);

    s = SFunction(ndist);
    s = s./dist;

    S = 0;
    for j=1:nPop-1
        
    S = S + 0.5*c*(ub-lb)*s(j).*(xi - GHs(j,:));

    end
    
    SI = S;
end

function s = SFunction(d)

    f = 0.5;
    l = 1.5;

    s = f * exp(-d/l) - exp(-d);

end