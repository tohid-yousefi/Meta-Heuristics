function [z, Out] = SVMCost(x,Data)

global NFE;
if isempty(NFE)
    NFE = 0;
end
NFE = NFE + 1;


Features = Data.Feature;
Labels = Data.Labels;
K = Data.K;
CVI = Data.CVI;
KernelFunction = Data.KernelFunction;

BC = 1e-4 + x(1) * 1e3;
SVMParams(1) = BC;
switch KernelFunction

    case 'linear'
        temsvm = templateSVM(BoxConstraint=BC,KernelFunction="linear");
    case 'rbf'
        KS = 1e-4 + x(2) * 1e3;
        SVMParams(2) = KS;
        temsvm = templateSVM(BoxConstraint=BC,KernelFunction="rbf",KernelScale=KS);
    case 'polynomial'
        q = max(1,round(x(1)*10));
        SVMParams(2) = q;
        temsvm = templateSVM(BoxConstraint=BC,KernelFunction="polynomial",PolynomialOrder=q);
end

AccuracyTrain = zeros(1,K);
AccuracyValid = zeros(1,K);
for i=1:K
    
    TrainF = Features(CVI~=i,:);
    TrainL = Labels(CVI~=i);

    Classify = fitcecoc(TrainF,TrainL,'Learners',temsvm);
    ClassTrain = predict(Classify,TrainF);
    CMT = confusionmat(TrainL,ClassTrain);
    AccuracyTrain(i) = sum(diag(CMT))/sum(CMT(:));

    ValidF = Features(CVI==i,:);
    ValidL = Labels(CVI==i);

    ClassValid = predict(Classify,ValidF);
    CMV = confusionmat(ValidL,ClassValid);
    AccuracyValid(i) = sum(diag(CMV)) / sum(CMV(:));
    
    Cl(i).Classify = Classify;
end

[~,idmax] = max(AccuracyValid);
Classify = Cl(idmax).Classify;
z = 1 - mean(AccuracyValid);

Out.z = z;
Out.Classify = Classify;
Out.AccuracyTrain = AccuracyTrain;
Out.AccuracyValid = AccuracyValid;
Out.SVMParams = SVMParams;
Out.Data = Data;

end