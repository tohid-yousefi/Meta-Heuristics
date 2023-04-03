clc;
clear;
close all;

%% Problem Definition

model = CreateModel();    % Create Knapsack Problem Model

CostFunction=@(xhat) MyCost(xhat, model);    % Cost Function

nVar=model.n;            % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

VarMin=0;          % Lower Bound of Decision Variables
VarMax=1;          % Upper Bound of Decision Variables

%% DE Parameters

MaxIt=100;      % Maximum Number of Iterations

nPop=50;        % Population Size

beta_min=0.2;   % Lower Bound of Scaling Factor
beta_max=0.8;   % Upper Bound of Scaling Factor

pCR=0.2;        % Crossover Probability

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Sol = [];

BestSol.Cost=inf;

pop=repmat(empty_individual,nPop,1); % Create Initial Population Array

for i=1:nPop

    pop(i).Position=CreateRandomSolution(model);
    
    [pop(i).Cost, pop(i).Sol]=CostFunction(pop(i).Position);
    
    if pop(i).Cost<BestSol.Cost
        BestSol=pop(i);
    end
    
end

BestCost=zeros(MaxIt,1);

%% DE Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        x=pop(i).Position;
        
        A=randperm(nPop);
        
        A(A==i)=[];
        
        a=A(1);
        b=A(2);
        c=A(3);
        
        % Mutation
        %beta=unifrnd(beta_min,beta_max);
        beta=unifrnd(beta_min,beta_max,VarSize);
        y=pop(a).Position+beta.*(pop(b).Position-pop(c).Position);
        
        % Clipping
        y = max(y, 0);
        y = min(y, 1);

        % Crossover
        z=zeros(size(x));
        j0=randi([1 numel(x)]);
        for j=1:numel(x)
            if j==j0 || rand<=pCR
                z(j)=y(j);
            else
                z(j)=x(j);
            end
        end
        
        NewSol.Position=z;
        [NewSol.Cost, NewSol.Sol]=CostFunction(NewSol.Position);
        
        if NewSol.Cost<pop(i).Cost
            pop(i)=NewSol;
            
            if pop(i).Cost<BestSol.Cost
               BestSol=pop(i);
            end
        end
        
    end
    
    % Update Best Cost
    BestCost(it)=BestSol.Cost;
    
    % Show Iteration Information
    if BestSol.Sol.IsFeasible
        FLAG=' *';
    else
        FLAG=[' Viol. = ' num2str(BestSol.Sol.Violation)];
    end
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) FLAG]);
    
end

%% Show Results

figure;
plot(BestCost);
% semilogy(BestCost);




