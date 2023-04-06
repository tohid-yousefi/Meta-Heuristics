clc;
clear;
close all;

%% Problem Definition

model = CreateModel();

CostFunction=@(xhat) MyCost(xhat, model);      % Cost Function

nVar=model.n;             % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin=0;          % Lower Bound of Variables
VarMax=1;          % Upper Bound of Variables

% Number of Objective Functions
nObj=numel(CostFunction(unifrnd(VarMin,VarMax,VarSize)));


%% NSGA-II Parameters

MaxIt=100;      % Maximum Number of Iterations

nPop=50;        % Population Size

pCrossover=0.7;                         % Crossover Percentage
nCrossover=2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

pMutation=0.4;                          % Mutation Percentage
nMutation=round(pMutation*nPop);        % Number of Mutants

mu=0.02;                    % Mutation Rate

sigma=0.1*(VarMax-VarMin);  % Mutation Step Size


%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Sol=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];

pop=repmat(empty_individual,nPop,1);

% Initialize Best Solution
BestSol.Sol.VB = inf;

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    [pop(i).Cost, pop(i).Sol]=CostFunction(pop(i).Position);

    if pop(i).Sol.IsFeasible && pop(i).Sol.VB<BestSol.Sol.VB
        BestSol = pop(i);
    end
    
end

% Non-Dominated Sorting
[pop, F]=NonDominatedSorting(pop);

% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);

% Sort Population
[pop, F]=SortPopulation(pop);

%% NSGA-II Main Loop

for it=1:MaxIt
    
    % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    for k=1:nCrossover/2
        
        i1=randi([1 nPop]);
        p1=pop(i1);
        
        i2=randi([1 nPop]);
        p2=pop(i2);
        
        [popc(k,1).Position popc(k,2).Position]=Crossover(p1.Position,p2.Position); %#ok
        
        popc(k,1).Position = max(popc(k,1).Position, VarMin);
        popc(k,1).Position = min(popc(k,1).Position, VarMax);
        
        popc(k,2).Position = max(popc(k,2).Position, VarMin);
        popc(k,2).Position = min(popc(k,2).Position, VarMax);

        [popc(k,1).Cost, popc(k,1).Sol]=CostFunction(popc(k,1).Position);
        [popc(k,2).Cost, popc(k,2).Sol]=CostFunction(popc(k,2).Position);
        
    end
    popc=popc(:);
    
    % Mutation
    popm=repmat(empty_individual,nMutation,1);
    for k=1:nMutation
        
        i=randi([1 nPop]);
        p=pop(i);
        
        popm(k).Position=Mutate(p.Position,mu,sigma);

        popm(k).Position = max(popm(k).Position, VarMin);
        popm(k).Position = min(popm(k).Position, VarMax);
        
        [popm(k).Cost, popm(k).Sol]=CostFunction(popm(k).Position);
        
    end
    
    % Merge
    pop=[pop
         popc
         popm]; %#ok
     
    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop, F]=SortPopulation(pop); %#ok
    
    % Truncate
    pop=pop(1:nPop);

    for i=1:numel(pop)
        if pop(i).Sol.IsFeasible && pop(i).Sol.VB<BestSol.Sol.VB
            BestSol = pop(i);
        end
    end
    
    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop, F]=SortPopulation(pop);
    
    % Store F1
    F1=pop(F{1});
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % Plot F1 Costs
    figure(1);
    PlotCosts(F1);
    hold on
    plot(BestSol.Cost(1), BestSol.Cost(2), 'ok', 'MarkerSize', 12)
    plot([100 1700], [model.Wmax model.Wmax], 'b', 'LineWidth',2);
    hold off
    
end 









