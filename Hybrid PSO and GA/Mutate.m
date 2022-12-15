function y = Mutate(x,VarRange)
    nVar = numel(x);
    j = randi([1, nVar]);

    VarMin = min(VarRange);
    VarMax = max(VarRange);
    sigma = (VarMax-VarMin)/10;

    y=x;
    y(j) = x(j)+sigma*randn;

    y = min(max(y,VarMin),VarMax);
end