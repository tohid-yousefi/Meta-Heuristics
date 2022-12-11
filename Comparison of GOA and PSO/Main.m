%% Start of Program
clc;
clear;
close all;

%% Problem Definition
global NFE;
NFE=0;

NameFunctions = {'Sphere','Rastrigin','Rosenbrock'};

%% Set Params
Params.MaxIt = 100;
Params.nPop = 50;
nRun = 3;

%% Optimization
for n=1:numel(NameFunctions)
    name = NameFunctions{n};
    P = Problems(name);
    for i=1:nRun
        RGOA(i) = RunGOA(P,Params);
        bGOA(i) = RGOA(i).BestSol.Cost;
        disp(['GOA, Function: ',name,' Run: ',num2str(i),', Best Cost: ', num2str(bGOA(i))]);
    end
    disp(['GOA, Function: ',name, ', Mean Best Cost: ', num2str(mean(bGOA))])
    for i=1:nRun
        RPSO(i) = RunPSO(P,Params);
        bPSO(i) = RPSO(i).BestSol.Cost;
        disp(['PSO, Function: ',name,' Run:',num2str(i),', Best Cost: ', num2str(bPSO(i))]);
    end
    disp(['PSO, Function: ',name, ', Mean Best Cost: ', num2str(mean(bPSO))])

    GOA(n).RGOA = RGOA;
    GOA(n).BC = bGOA;
    PSO(n).RPSO = RPSO;
    PSO(n).BC = bPSO;

end

for i=1:n
    GOA_Time(i,1) = mean([GOA(i).RGOA.Time]);
    GOA_BCost(i,1) = mean(GOA(i).BC);
    GOA_Bstd(i,1) = std(GOA(i).BC);

    PSO_Time(i,1) = mean([PSO(i).RPSO.Time]);
    PSO_BCost(i,1) = mean(PSO(i).BC);
    PSO_Bstd(i,1) = std(PSO(i).BC);
end

T = table(GOA_Time,PSO_Time,GOA_BCost,PSO_BCost,GOA_Bstd,PSO_Bstd,RowNames=NameFunctions);
disp(T)