function Results = RunPSO(P,Params)

%% Problem Definition
global NFE;
NFE=0;
CostFunction = P.CostFunction;  % Cost Function

nVar = P.nVar;                       % Number of Decision Variables
VarSize =[1 nVar];                   % Size of Variables
VarMin = P.VarMin;                   % Lower Bound of Variable
VarMax = P.VarMax;                    % Upper Bound of Variable

%%  PSO Parameters
MaxIt = Params.MaxIt ;                              % Maximum Number of Iteration
nPop = Params.nPop;                                  % Population Size (Swarm Size)
w = 1;                                      % Inertia Weight
wdamp = 0.99;                               % Inertia Weight Damping Ratio
c1 = 2;                                     % Personal Learning Coefficient
c2 = 2;                                     % Global Learning Coefficient

% Velocity Limits
VelMax = 0.1*(VarMax - VarMin);
VelMin = -VelMax;

tic;
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
    particle(i).Position = unifrnd(VarMin,VarMax,VarSize);
    % Initialize Velocity
    particle(i).Velocity = zeros(VarSize);
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

        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            + c1*rand(VarSize).*(particle(i).Best.Position - particle(i).Position)...
            + c2*rand(VarSize).*(GlobalBest.Position - particle(i).Position);

        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);

        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;

        % Velocity Mirror Effect
        IsOutside = (particle(i).Position<VarMin | particle(i).Position > VarMax);
        particle(i).Velocity(IsOutside) = -particle(i).Velocity(IsOutside);

        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);

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
   
    w = w*wdamp; 

end

t = toc;

%% Results
Results.BestCost = BestCost;
Results.BestSol = GlobalBest;
Results.nfe = nfe;
Results.Time = t;

end