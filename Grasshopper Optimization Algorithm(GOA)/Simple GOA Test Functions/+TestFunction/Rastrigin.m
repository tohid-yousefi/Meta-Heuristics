function [z ,Out] = Rastrigin(x)
    
    global NFE;

    if isempty(NFE)
        NFE=0;
    end
    NFE=NFE+1;

    d = numel(x);
    sum = 0;
    for ii = 1:d
	    xi = x(ii);
	    sum = sum + (xi^2 - 10*cos(2*pi*xi));
    end
    
    z = 10*d + sum;

    Out.z = z;
    
end