%% Start of Program
clc;
clear;
close all;

%% Problem Definition
global NFE;
NFE=0;

model = CreateModel();

CostFunction = @(x) MyCost(x,model);            % Cost Function
nVar = model.N;                                 % Number of Decision Variables
VarSize = [1 nVar];                             % Size of Decision Variables Matrix
VarMin = 0;                                     % Lower Bound of Variables
VarMax = 1;                                     % Upper Bound of Variables


%% GOA Parameters
MaxIt = 200;                    % Maximum Number of Iterations
nPop = 100;                       % Population Size

% constriction Coefficient
cMax = 1;
cMin = 1e-4;

Paramas.lb = VarMin;
Paramas.ub = VarMax;
Paramas.nPop = nPop;

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
MeanCost = zeros(1,MaxIt);
WorstCost = zeros(1,MaxIt);
nfe = zeros(1,MaxIt);

%% GOA Main Loop
for it=1:MaxIt

    c = cMax - it * ((cMax - cMin)/MaxIt);          % Update c Parameter
    Paramas.c = c;

    for i=1:nPop
    
        Paramas.i = i;
        GrassHoppers = cat(1,GrassHopper.Position);     % Position of All GrassHoppers
        SI = SocialInteraction(GrassHoppers, Paramas);              % Calculate Social Interaction
        GrassHopper(i).Position = c*SI + GlobalBest.Position;       % Calculate Grasshopper Position

        GrassHopper(i).Position = min(max(GrassHopper(i).Position,VarMin),VarMax);
        
        % Evaluation
        [GrassHopper(i).Cost, GrassHopper(i).Out] = CostFunction(GrassHopper(i).Position);        % Evaluation
        
        % Update Target
        if GrassHopper(i).Cost < GlobalBest.Cost
            GlobalBest = GrassHopper(i);
        end
    end

    BestCost(it) = GlobalBest.Cost;
    MeanCost(it) = mean([GrassHopper.Cost]);
    WorstCost(it) = max([GrassHopper.Cost]);
    nfe(it) = NFE;

        % Display Results on Command Line
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);
    
    figure(1);
    PlotSolution(GlobalBest.Out.Tour,model)
end

%% Plot Results
figure
% plot(1:MaxIt,BestCost,'LineWidth',2)
semilogy(1:MaxIt,BestCost,'LineWidth',2)
hold on
semilogy(1:MaxIt,MeanCost,'LineWidth',2)
hold on
semilogy(1:MaxIt,WorstCost,'LineWidth',2)
legend('Best Cost','Mean Cost','Worst Cost');
xlabel('Iteration')
ylabel('Best Cost')
title('Trend GOA for TSP')

figure
% plot(1:MaxIt,BestCost,'LineWidth',2)
semilogy(nfe,BestCost,'LineWidth',2)
hold on
semilogy(nfe,MeanCost,'LineWidth',2)
hold on
semilogy(nfe,WorstCost,'LineWidth',2)
legend('Best Cost','Mean Cost','Worst Cost');
xlabel('NFE')
ylabel('Best Cost')
title('Trend GOA for TSP')