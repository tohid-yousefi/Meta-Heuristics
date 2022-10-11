function model = CreateModel()
    
    % Item Values
    v = [4 3 20 4 1 12 18 14 4 8 10 20];

    % Item Weights
    w = [16 45 36 25 17 27 29 14 34 19 25 33];

    % tem Counts
    M = [3 3 5 3 7 8 6 3 5 1 8 8];

    % Max Weights
    W = sum(w.*M)/2;
    
    % Number of Items
    N = numel(v);
    
    % Export Model Data
    model.N = N;
    model.v = v;
    model.w = w;
    model.W = W;
    model.M = M;


end