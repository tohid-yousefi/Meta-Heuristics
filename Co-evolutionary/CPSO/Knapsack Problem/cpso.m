clc;
clear;
close all;

%% Problem Definition

model = CreateModel();

% Internal PSO Params
params.MaxIt = 100;
params.nPop = 50;
params.w = 1;
params.wdamp = 0.999;
params.c1 = 2;
params.c2 = 2;
params.nVar = model.n;
params.VarMin = 0;
params.VarMax = 1; 
params.phi = 0.1;

CostFunction=@(alpha) ExternalCost(alpha, params, model);        % Cost Function

nVar=1;             % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin=0.001;         % Lower Bound of Variables
VarMax=10;         % Upper Bound of Variables


%% PSO Parameters

MaxIt=20;      % Maximum Number of Iterations

nPop=10;        % Population Size (Swarm Size)

% w=1;            % Inertia Weight
% wdamp=0.99;     % Inertia Weight Damping Ratio
% c1=2;           % Personal Learning Coefficient
% c2=2;           % Global Learning Coefficient

% Constriction Coefficients
phi1=2.05;
phi2=2.05;
phi=phi1+phi2;
chi=2/(phi-2+sqrt(phi^2-4*phi));
w=chi;          % Inertia Weight
wdamp=1;        % Inertia Weight Damping Ratio
c1=chi*phi1;    % Personal Learning Coefficient
c2=chi*phi2;    % Global Learning Coefficient

% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;

%% Initialization

empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Out=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];

particle=repmat(empty_particle,nPop,1);

BestSol.Cost=inf;

InternalBestSol.Cost = inf;

for i=1:nPop
    
    % Initialize Position
    particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
    [particle(i).Cost, particle(i).Out]=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Out=particle(i).Out;
    
    % Update Global Best
    if particle(i).Best.Cost<BestSol.Cost
        
        BestSol=particle(i).Best;
        
    end

    % Update Internal Best Solution Ever Found
    if particle(i).Out.BestSol.Sol.IsFeasible
        if particle(i).Out.BestSol.Cost < InternalBestSol.Cost
            InternalBestSol = particle(i).Out.BestSol;
        end
    end
    
end

particle = CalcInvalidCosts(particle);
for i=1:nPop
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Out=particle(i).Out;
    
    % Update Global Best
    if particle(i).Best.Cost<BestSol.Cost
        
        BestSol=particle(i).Best;
        
    end
end

BestCost=zeros(MaxIt,1);


%% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(BestSol.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
        [particle(i).Cost, particle(i).Out] = CostFunction(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Out=particle(i).Out;
            
            % Update Global Best
            if particle(i).Best.Cost<BestSol.Cost
                
                BestSol=particle(i).Best;
                
            end
            
        end
        
        % Update Internal Best Solution Ever Found
        if particle(i).Out.BestSol.Sol.IsFeasible
            if particle(i).Out.BestSol.Cost < InternalBestSol.Cost
                InternalBestSol = particle(i).Out.BestSol;
            end
        end
    end

    particle = CalcInvalidCosts(particle);
    for i=1:nPop
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Out=particle(i).Out;
            
            % Update Global Best
            if particle(i).Best.Cost<BestSol.Cost
                BestSol=particle(i).Best;
            end
            
        end
    end

    BestCost(it)=BestSol.Cost;
    
    disp(['Iteration ' num2str(it) ', Best Cost = ' num2str(BestCost(it))]);
    
    w=w*wdamp;
    
end

%% Results

figure;
%plot(BestCost,'LineWidth',2);
semilogy(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');

