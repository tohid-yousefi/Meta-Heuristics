function [z ,Out]= MyCost(p,model)

    global NFE;
    if isempty(NFE)
        NFE = 0;
    end
    NFE = NFE + 1;

    a0 = model.a0;
    a1 = model.a1;
    a2 = model.a2;
    PL = model.PL;

%     c = zeros(size(p));
%     for i=1:N
%         
%         c(i) = a0(i)+a1(i)*p(i)+a2(i)*p(i)^2;
% 
%     end
    
    % Vectorized version of previous loop
    c = a0+a1.*p+a2.*p.^2;
    v = abs(sum(p)/PL-1);
    beta = 10;
    z = sum(c)*(1+beta*v);

    Out.p = p;
    Out.pTotal = sum(p);
    Out.c = c;
    Out.cTotal = sum(c);
    Out.v = v;
    Out.z = z;

end