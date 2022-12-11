function Results = RunGOA(P,Params)

%% Problem Definition
global NFE;
NFE=0;

CostFunction = P.CostFunction;  % Cost Function

nVar = P.nVar;                       % Number of Decision Variables
VarSize =[1 nVar];              % Size of Variables
VarMin = P.VarMin;                   % Lower Bound of Variable
VarMax = P.VarMax;                    % Upper Bound of Variable

%% GOA Parameters
MaxIt = Params.MaxIt;                    % Maximum Number of Iterations
nPop = Params.nPop;                       % Population Size

% constriction Coefficient
cMax = 1;
cMin = 1e-4;

Params.lb = VarMin;
Params.ub = VarMax;
Params.nPop = nPop;

tic;
%% Initialization
empty_GrassHopper.Position = [];
empty_GrassHopper.Cost = [];
empty_GrassHopper.Out = [];

GrassHopper = repmat(empty_GrassHopper,nPop,1);

for i=1:nPop
    
    % Initialize Position
    GrassHopper(i).Position = unifrnd(VarMin,VarMax,VarSize);
    
    % Evaluate
    [GrassHopper(i).Cost, GrassHopper(i).Out] = CostFunction(GrassHopper(i).Position);

end

[~, indx] = min([GrassHopper.Cost]);
GlobalBest = GrassHopper(indx);                   % Target GrassHopper

BestCost = zeros(1,MaxIt);
nfe = zeros(1,MaxIt);
w = 0.5;

%% GOA Main Loop
for it=1:MaxIt

    c = cMax - it * ((cMax - cMin)/MaxIt);          % Update c Parameter
    cNew = cMin + (cMax - (it/MaxIt).^w).^(cMax/w)*(1 - cMin);

    Params.c = c;

    for i=1:nPop
    
        Params.i = i;
        GrassHoppers = cat(1,GrassHopper.Position);     % Position of All GrassHoppers
        SI = SocialInteraction(GrassHoppers, Params);              % Calculate Social Interaction
        %GrassHopper(i).Position = c*SI.*(0.01*unifrnd(VarMin,VarMax,[1,nVar])) + GlobalBest.Position;       % Calculate Grasshopper Position
        GrassHopper(i).Position = cNew*SI.*(0.01*unifrnd(VarMin,VarMax,VarSize)) + GlobalBest.Position;       % Calculate Grasshopper Position

        GrassHopper(i).Position = min(max(GrassHopper(i).Position,VarMin),VarMax);
        
        % Evaluation
        [GrassHopper(i).Cost, GrassHopper(i).Out] = CostFunction(GrassHopper(i).Position);        % Evaluation
        
        % Update Target
        if GrassHopper(i).Cost < GlobalBest.Cost
            GlobalBest = GrassHopper(i);
        end
    end

    BestCost(it) = GlobalBest.Cost;
    nfe(it) = NFE;

end
t = toc;

%% Results
Results.BestCost = BestCost;
Results.BestSol = GlobalBest;
Results.nfe = nfe;
Results.Time = t;

end