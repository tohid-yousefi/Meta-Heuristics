%% Start of Program
clc;
clear;
close all;

%% Problem Definition
CostFunction = @(x) Sphere(x);  % Cost Function

nVar = 3;                       % Number of Decision Variables
VarSize =[1 nVar];              % Size of Variables
VarMin = -100;                   % Lower Bound of Variable
VarMax = 100;                    % Upper Bound of Variable


%% GOA Parameters
MaxIt = 100;                    % Maximum Number of Iterations
nPop = 50;                       % Population Size

% constriction Coefficient
cMax = 1;
cMin = 1e-4;

Paramas.lb = VarMin;
Paramas.ub = VarMax;
Paramas.nPop = nPop;

%% Initialization
empty_GrassHopper.Position = [];
empty_GrassHopper.Cost = [];

GrassHopper = repmat(empty_GrassHopper,nPop,1);

for i=1:nPop
    
    % Initialize Position
    GrassHopper(i).Position = unifrnd(VarMin,VarMax,VarSize);
    
    % Evaluate
    GrassHopper(i).Cost = CostFunction(GrassHopper(i).Position);

end
NFE = nPop;
[~, indx] = min([GrassHopper.Cost]);
TargetGH = GrassHopper(indx);                   % Target GrassHopper

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
        GrassHopper(i).Position = c*SI + TargetGH.Position;       % Calculate Grasshopper Position

        GrassHopper(i).Position = min(max(GrassHopper(i).Position,VarMin),VarMax);
        
        % Evaluation
        GrassHopper(i).Cost = CostFunction(GrassHopper(i).Position);        % Evaluation
        
        % Update Target
        if GrassHopper(i).Cost < TargetGH.Cost
            TargetGH = GrassHopper(i);
        end
    end

    BestCost(it) = TargetGH.Cost;
    MeanCost(it) = mean([GrassHopper.Cost]);
    WorstCost(it) = max([GrassHopper.Cost]);
    NFE = NFE + nPop;
    nfe(it) = NFE;

        % Display Results on Command Line
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);

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
title('Trend GOA for Sphere Function')

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
title('Trend GOA for Sphere Function')