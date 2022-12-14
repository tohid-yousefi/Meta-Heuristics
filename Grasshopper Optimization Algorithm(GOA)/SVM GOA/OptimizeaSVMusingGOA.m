function Results = OptimizeaSVMusingGOA(TrainData,Params)

%% Problem Definition
global NFE;
NFE=0;

CostFunction = @(x)SVMCost(x,TrainData);  % Cost Function

if strcmp(TrainData.KernelFunction,'linear')
    nVar = 1;
else
    nVar = 2;
end
VarSize =[1 nVar];              % Size of Variables
VarMin = 0;                   % Lower Bound of Variable
VarMax = 1;                    % Upper Bound of Variable

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
        GrassHopper(i).Position = 10*cNew*SI + GlobalBest.Position;       % Calculate Grasshopper Position

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

    % Display Results on Command Line
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);

end
t = toc;

%% Plot Results
figure;
plot(1:MaxIt,BestCost,'LineWidth',2)

%% Results
[~, Out] = CostFunction(GlobalBest.Position);
Results.BestCost = BestCost;
Results.BestSol = GlobalBest;
Results.nfe = nfe;
Results.Time = t;
Results.Out = Out;


end