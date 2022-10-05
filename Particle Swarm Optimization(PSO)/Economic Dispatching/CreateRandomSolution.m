function p = CreateRandomSolution(model)

    pmin = model.pmin;
    pmax = model.pmax;

    p = unifrnd(pmin,pmax);

end