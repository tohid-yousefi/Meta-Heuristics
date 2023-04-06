function out=RunInternalPSO(alpha, params, model)
    
    %% Problem Definition
    
    CostFunction=@(xhat) InternalCost(xhat, model, alpha);        % Cost Function
    
    nVar=params.nVar;             % Number of Decision Variables
    
    VarSize=[1 nVar];   % Size of Decision Variables Matrix
    
    VarMin=params.VarMin;         % Lower Bound of Variables
    VarMax=params.VarMax;         % Upper Bound of Variables
    
    
    %% PSO Parameters
    
    MaxIt=params.MaxIt;      % Maximum Number of Iterations
    
    nPop=params.nPop;        % Population Size (Swarm Size)
    
    w=params.w;             % Inertia Weight
    wdamp=params.wdamp;     % Inertia Weight Damping Ratio
    c1=params.c1;           % Personal Learning Coefficient
    c2=params.c2;           % Global Learning Coefficient
    
   
    % Velocity Limits
    phi = params.phi;
    VelMax=phi*(VarMax-VarMin);
    VelMin=-VelMax;
    
    %% Initialization
    
    empty_particle.Position=[];
    empty_particle.Cost=[];
    empty_particle.Sol=[];
    empty_particle.Velocity=[];
    empty_particle.Best.Position=[];
    empty_particle.Best.Cost=[];
    
    particle=repmat(empty_particle,nPop,1);
    
    BestSol.Cost=inf;
    
    for i=1:nPop
        
        % Initialize Position
        particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
        
        % Initialize Velocity
        particle(i).Velocity=zeros(VarSize);
        
        % Evaluation
        [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);
        
        % Update Personal Best
        particle(i).Best.Position=particle(i).Position;
        particle(i).Best.Cost=particle(i).Cost;
        particle(i).Best.Sol=particle(i).Sol;
        
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
            [particle(i).Cost, particle(i).Sol] = CostFunction(particle(i).Position);
            
            % Update Personal Best
            if particle(i).Cost<particle(i).Best.Cost
                
                particle(i).Best.Position=particle(i).Position;
                particle(i).Best.Cost=particle(i).Cost;
                particle(i).Best.Sol=particle(i).Sol;
                
                % Update Global Best
                if particle(i).Best.Cost<BestSol.Cost
                    
                    BestSol=particle(i).Best;
                    
                end
                
            end
            
        end
        
        BestCost(it)=BestSol.Cost;
       
        w=w*wdamp;
        
    end

    %% Export Results
    S = [particle.Sol];
    FeasiblePop = particle([S.IsFeasible]);
    nFeasible = numel(FeasiblePop);
    MeanFeasibleCost = mean([FeasiblePop.Cost]);
    TotalSumViol = sum([S.SumViol]);
    TotalNumViol = sum([S.NumViol]);
    TotalMeanViol = TotalSumViol / TotalNumViol;

    out.Pop = particle;
    out.BestSol = BestSol;
    out.BestCost = BestCost;
    out.FeasiblePop = FeasiblePop;
    out.nFeasible = nFeasible;
    out.MeanFeasibleCost = MeanFeasibleCost;
    out.TotalSumViol = TotalSumViol;
    out.TotalNumViol = TotalNumViol;
    out.TotalMeanViol = TotalMeanViol;

end