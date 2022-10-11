function x = ParseSolution(xhat,model)

    M = model.M;
    x = min(floor((M+1).*xhat),M);

end