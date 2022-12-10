function [z, Out] = Rosenbrock(x)
    
    global NFE;

    if isempty(NFE)
        NFE=0;
    end
    NFE=NFE+1;

    d = numel(x);
    sum = 0;
    for ii = 1:(d-1)
	    xi = x(ii);
	    xnext = x(ii+1);
	    new = 100*(xnext-xi^2)^2 + (xi-1)^2;
	    sum = sum + new;
    end
    
    z = sum;

    Out.z = z;

end