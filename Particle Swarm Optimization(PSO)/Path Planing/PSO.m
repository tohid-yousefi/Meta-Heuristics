%% Start of Program
clc;
clear;
close all;

%% Problem Definition
global NFE;
NFE=0;

model = CreateModel();
model.n = 3;

CostFunction = @(x) MyCost(x,model);                % Cost Function
nVar = model.n;                                     % Number of Decision Variables
VarSize = [1 nVar];                                 % Size of Decision Variables Matrix
VarMin.x = model.xmin;                              % Lower Bound of Variables 
VarMax.x = model.xmax;                              % Upper Bound of Variables
VarMin.y = model.ymin;                              % Lower Bound of Variables 
VarMax.y = model.ymax;                              % Upper Bound of Variables

%%  PSO Parameters
MaxIt = 500 ;                               % Maximum Number of Iteration
nPop = 100;                                 % Population Size (Swarm Size)
w = 1;                                      % Inertia Weight
wdamp = 0.99;                               % Inertia Weight Damping Ratio
c1 = 2;                                     % Personal Learning Coefficient
c2 = 2;                                     % Global Learning Coefficient

% Constriction Coefficient
% phi1 = 2.05;
% phi2 = 2.05;
% phi = phi1+phi2;
% chi = 2/(phi-2+sqrt(phi^2-4*phi));
% w = chi;                                  % Inertia Weight
% wdamp = 1;                                % Inertia Weight Damping Ratio
% c1 = chi*phi1;                            % Personal Learning Coefficient
% c2 = chi*phi2;                            % Global Learning Coefficient

% Velocity Limits
alpha = 0.1;
VelMax.x = alpha*(VarMax.x - VarMin.x);
VelMin.x = -VelMax.x;
VelMax.y = alpha*(VarMax.y - VarMin.y);
VelMin.y = -VelMax.y;

%% Initialization
empty_particle.Position = [];
empty_particle.Cost = [];
empty_particle.Out = [];
empty_particle.Velocity = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];

particle = repmat(empty_particle,nPop,1);
GlobalBest.Cost = inf;

for i=1:nPop
    
    % Initialize Position
    particle(i).Position = CreateRandomSolution(model);
    % Initialize Velocity
    particle(i).Velocity.x = zeros(VarSize);
    particle(i).Velocity.y = zeros(VarSize);
    % Evaluation
    [particle(i).Cost ,particle(i).Out] = CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position = particle(i).Position;
    particle(i).Best.Cost = particle(i).Cost;
    particle(i).Best.Out = particle(i).Out;
    
    % Update Global Best
    if particle(i).Best.Cost < GlobalBest.Cost

        %GlobalBest.Position = particle(i).Best.Position;
        %GlobalBest.Cost = particle(i).Best.Cost;

        GlobalBest = particle(i).Best;

    end

end

BestCost = zeros(MaxIt,1);
nfe = zeros(MaxIt,1);

%% PSO Main Loop
for it=1:MaxIt

    for i=1:nPop
        
        % x Part

        % Update Velocity
        particle(i).Velocity.x = w*particle(i).Velocity.x ...
            + c1*rand(VarSize).*(particle(i).Best.Position.x - particle(i).Position.x)...
            + c2*rand(VarSize).*(GlobalBest.Position.x - particle(i).Position.x);

        % Apply Velocity Limits
        particle(i).Velocity.x = max(particle(i).Velocity.x,VelMin.x);
        particle(i).Velocity.x = min(particle(i).Velocity.x,VelMax.x);

        % Update Position
        particle(i).Position.x = particle(i).Position.x + particle(i).Velocity.x;

        % Velocity Mirror Effect
        IsOutside = (particle(i).Position.x<VarMin.x | particle(i).Position.x > VarMax.x);
        particle(i).Velocity.x(IsOutside) = -particle(i).Velocity.x(IsOutside);

        % Apply Position Limits
        particle(i).Position.x = max(particle(i).Position.x,VarMin.x);
        particle(i).Position.x = min(particle(i).Position.x,VarMax.x);

        % y Part

        % Update Velocity
        particle(i).Velocity.y = w*particle(i).Velocity.y ...
            + c1*rand(VarSize).*(particle(i).Best.Position.y - particle(i).Position.y)...
            + c2*rand(VarSize).*(GlobalBest.Position.y - particle(i).Position.y);

        % Apply Velocity Limits
        particle(i).Velocity.y = max(particle(i).Velocity.y,VelMin.y);
        particle(i).Velocity.y = min(particle(i).Velocity.y,VelMax.y);

        % Update Position
        particle(i).Position.y = particle(i).Position.y + particle(i).Velocity.y;

        % Velocity Mirror Effect
        IsOutside = (particle(i).Position.y<VarMin.y | particle(i).Position.y > VarMax.y);
        particle(i).Velocity.y(IsOutside) = -particle(i).Velocity.y(IsOutside);

        % Apply Position Limits
        particle(i).Position.y = max(particle(i).Position.y,VarMin.y);
        particle(i).Position.y = min(particle(i).Position.y,VarMax.y);


        % Evaluation
        [particle(i).Cost ,particle(i).Out] = CostFunction(particle(i).Position);

        % Update Personal Best
        if particle(i).Cost < particle(i).Best.Cost

            particle(i).Best.Position = particle(i).Position;
            particle(i).Best.Cost = particle(i).Cost;
            particle(i).Best.Out = particle(i).Out;

            % Update Gloabl Best
            if particle(i).Best.Cost < GlobalBest.Cost

                GlobalBest = particle(i).Best;

            end

        end        

    end
    
    BestCost(it) = GlobalBest.Cost;
    nfe(it) = NFE;
    
    % Display Results on Comman Line
    if GlobalBest.Out.IsFeasible
        Flag = ' *';
    else
        Flag = [', Violation = ' num2str(GlobalBest.Out.MeanViolation)];
    end
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it)) Flag]);

    % Plot Solution
    figure(1)
    PlotSolution(GlobalBest.Out,model)

    w = w*wdamp; 

end

%% Results
figure;
%plot(nfe,BestCost,'LineWidth',2)
semilogy(nfe,BestCost,'LineWidth',2)
xlabel('NFE')
ylabel('Best Cost')