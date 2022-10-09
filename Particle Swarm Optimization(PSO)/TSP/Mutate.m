function xnew = Mutate(x)

    [~, Tour] = sort(x);

    M = randi([1 3]);
    switch M
        case 1
            NewTour = DoSwap(Tour);
        case 2
            NewTour = DoReversion(Tour);
        case 3
            NewTour = DoInsertion(Tour);
    end

    xnew = zeros(size(x));
    xnew(NewTour) = x(Tour);

end

function NewTour = DoSwap(Tour)

    n = numel(Tour);
    i = randsample(n,2);
    i1 = i(1);
    i2 = i(2);

    NewTour = Tour;
    NewTour([i1 i2]) = Tour([i2 i1]); 

end

function NewTour = DoReversion(Tour)

    n = numel(Tour);
    i = randsample(n,2);
    i1 = min(i);
    i2 = max(i);

    NewTour = Tour;
    NewTour(i1:i2) = Tour(i2:-1:i1);

end

function NewTour = DoInsertion(Tour)

    n = numel(Tour);
    i = randsample(n,2);
    i1 = i(1);
    i2 = i(2);

    if i1<i2
        
        NewTour = [Tour(1:i1) Tour(i2) Tour(i1+1:i2-1) Tour(i2+1:end)];

    else

        NewTour = [Tour(1:i2-1) Tour(i2+1:i1) Tour(i2) Tour(i1+1:end)];

    end

end