function model=CreateModel()
    
    % Values
    V=[75    74    81    53    99    74    93    82    28    41 ...
       63    80    30    41    27    57    26    49    42    92 ...
       51    40    20    77    66    23    37    52    58    63 ...
       93    46    32    77    86    98    56    54    15    97];
    
    % Weights
    W=[19    48    59    30    53    63    56    26    67    61 ...
       23    45    96    20    67    87    41    39    63    32 ...
       45    38    59    70    29    53    67    36    24    80 ...
       43    87    12    70    82    18    91    40    46    71];

    % Number of Items
    n = numel(V);

    % Maximum Weight
    Wmax = 1285;
    
    % Export Model
    model.n = n;
    model.V = V;
    model.W = W;
    model.Wmax = Wmax;

end