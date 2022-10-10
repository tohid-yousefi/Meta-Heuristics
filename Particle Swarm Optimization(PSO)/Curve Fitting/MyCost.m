function [z, Out] = MyCost(a,model)
    
    global NFE;
    if isempty(NFE)
        NFE = 0;
    end
    NFE = NFE + 1;
    
    x = model.x;
    y = model.y;
    fhat = model.fhat;

    yhat = zeros(size(y));
    for i=1:numel(x)
        yhat(i) = fhat(x(i),a);
    end

    e = y - yhat;
    z = sum(e.^2);
    
    Out.yhat = yhat;
    Out.e = e;
    Out.z = z;
    
end