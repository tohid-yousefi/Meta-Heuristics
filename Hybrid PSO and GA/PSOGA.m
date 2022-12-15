%% Start of Program
clc;
clear;
close all;

%% Problem Definition
global NFE;
NFE=0;

CostFunction = @(x) Sphere(x);            % Cost Function
nVar = 10;                                % Number of Decision Variables
VarSize = [1 nVar];                       % Size of Decision Variables Matrix
VarMin = -10;                             % Lower Bound of Variables
VarMax = 10;                              % Upper Bound of Variables
VarRange = [VarMin VarMax];               % Variation Range of Variables

%%  PSO-GA Parameters
MaxIt = 1000 ;                              % Maximum Number of Iteration
MaxSubItPSO=2;                              % Maximum Number of Sub-Iterations for PSO
MaxSubItGA=1;                               % Maximum Number of Sub-Iterations for GA
nPop = 100;                                  % Population Size (Swarm Size)
w = 1;                                      % Inertia Weight
wdamp = 0.99;                               % Inertia Weight Damping Ratio
c1 = 2;                                     % Personal Learning Coefficient
c2 = 2;                                     % Global Learning Coefficient

% Velocity Limits
VelMax = 0.1*(VarMax - VarMin);
VelMin = -VelMax;

pCrossover = 0.7;                           % Crossover Percentage
nCrossover = round(pCrossover*nPop/2)*2;    % Number of Parents(Offspring)

pMutation = 0.2;                            % Mutation Percentage
nMutation = round(pMutation*nPop);          % Number of Mutatns

%% Initialization
empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Out = [];
empty_individual.Velocity = [];
empty_individual.Best.Position = [];
empty_individual.Best.Cost = [];

pop = repmat(empty_individual,nPop,1);
GlobalBest.Cost = inf;

for i=1:nPop
    
    % Initialize Position
    pop(i).Position = unifrnd(VarMin,VarMax,VarSize);
    % Initialize Velocity
    pop(i).Velocity = zeros(VarSize);
    % Evaluation
    [pop(i).Cost ,pop(i).Out] = CostFunction(pop(i).Position);
    
    % Update Personal Best
    pop(i).Best.Position = pop(i).Position;
    pop(i).Best.Cost = pop(i).Cost;
    pop(i).Best.Out = pop(i).Out;
    
    % Update Global Best
    if pop(i).Best.Cost < GlobalBest.Cost

        %GlobalBest.Position = pop(i).Best.Position;
        %GlobalBest.Cost = pop(i).Best.Cost;

        GlobalBest = pop(i).Best;

    end

end

% Sort Population
pop=SortPopulation(pop);

BestCost = zeros(MaxIt,1);
nfe = zeros(MaxIt,1);

%% PSO-GA Main Loop
for it=1:MaxIt
    
    % PSO Operators
    for psoit=1:MaxSubItPSO
        for i=1:nPop

        % Update Velocity
        pop(i).Velocity = w*pop(i).Velocity ...
            + c1*rand(VarSize).*(pop(i).Best.Position - pop(i).Position)...
            + c2*rand(VarSize).*(GlobalBest.Position - pop(i).Position);

        % Apply Velocity Limits
        pop(i).Velocity = max(pop(i).Velocity,VelMin);
        pop(i).Velocity = min(pop(i).Velocity,VelMax);

        % Update Position
        pop(i).Position = pop(i).Position + pop(i).Velocity;

        % Velocity Mirror Effect
        IsOutside = (pop(i).Position<VarMin | pop(i).Position > VarMax);
        pop(i).Velocity(IsOutside) = -pop(i).Velocity(IsOutside);

        % Apply Position Limits
        pop(i).Position = max(pop(i).Position,VarMin);
        pop(i).Position = min(pop(i).Position,VarMax);

        % Evaluation
        [pop(i).Cost ,pop(i).Out] = CostFunction(pop(i).Position);

        % Update Personal Best
        if pop(i).Cost < pop(i).Best.Cost

            pop(i).Best.Position = pop(i).Position;
            pop(i).Best.Cost = pop(i).Cost;
            pop(i).Best.Out = pop(i).Out;

            % Update Gloabl Best
            if pop(i).Best.Cost < GlobalBest.Cost

                GlobalBest = pop(i).Best;

            end

        end        

        end
    end
    
    % GA Operators
    for gait=1:MaxSubItGA    
        % Crossover
        popc=repmat(empty_individual,nCrossover/2,2);
            for k=1:nCrossover/2
    
                i1=randi([1 nPop]);
                i2=randi([1 nPop]);
    
                p1=pop(i1);
                p2=pop(i2);
    
                [popc(k,1).Position, popc(k,2).Position]=Crossover(p1.Position,p2.Position,VarRange);
    
                popc(k,1).Cost=CostFunction(popc(k,1).Position);
                popc(k,2).Cost=CostFunction(popc(k,2).Position);
    
                if p1.Best.Cost<p2.Best.Cost
                    popc(k,1).Best=p1.Best;
                    popc(k,2).Best=p1.Best;
                else
                    popc(k,1).Best=p2.Best;
                    popc(k,2).Best=p2.Best;
                end
    
                if rand<0.5
                    popc(k,1).Velocity=p1.Velocity;
                    popc(k,2).Velocity=p2.Velocity;
                else
                    popc(k,1).Velocity=p2.Velocity;
                    popc(k,2).Velocity=p1.Velocity;
                end
    
            end
            popc=popc(:);
    
    
        % Mutation
        popm = repmat(empty_individual,nMutation,1);
        for k=1:nMutation
            i = randi([1, nPop]);
            p = pop(i);
    
            popm(k).Position = Mutate(p.Position,VarRange);
    
            [popm(k).Cost, popm(k).Out] = CostFunction(popm(k).Position);
    
            popm(k).Velocity = p.Velocity;
            popm(k).Best = p.Best;
        end
    
        % Merge Population
        pop=[pop
             popc
             popm];
    
        % Sort Population
        pop = SortPopulation(pop);
    
        % Remove Extra Individuals
        pop = pop(1:nPop);
        
        for i=1:nPop
            % Update Personal Best
            if pop(i).Cost < pop(i).Best.Cost
        
                pop(i).Best.Position = pop(i).Position;
                pop(i).Best.Cost = pop(i).Cost;
                pop(i).Best.Out = pop(i).Out;
        
                % Update Gloabl Best
                if pop(i).Best.Cost < GlobalBest.Cost
        
                    GlobalBest = pop(i).Best;
        
                end
        
            end
        end
    end

    BestCost(it) = GlobalBest.Cost;
    nfe(it) = NFE;
    
    % Display Results on Command Line
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);

    w = w*wdamp; 

end

%% Results
figure;
%plot(nfe,BestCost,'LineWidth',2)
semilogy(nfe,BestCost,'LineWidth',2)
xlabel('NFE')
ylabel('Best Cost')