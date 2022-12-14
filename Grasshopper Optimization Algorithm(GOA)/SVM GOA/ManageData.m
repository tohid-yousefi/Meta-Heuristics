function [TrainData, TestData] = ManageData(data)
    
    Labels = data(:,end);
    Features = data(:,1:end-1);

    % Normalization
    Features = Normalization(Features);
    
    % Divide Train and Test Data
    pTrain = 70;
    [nSamples, nFeature] = size(Features);
    nTrain = round((pTrain/100)*nSamples);

    R = randperm(nSamples);
    indTrain = R(1:nTrain);
    indTest = R(nTrain+1:end);

    TrainData.Feature = Features(indTrain,:);
    TrainData.Labels = Labels(indTrain,:);
    TrainData.nFeature = nFeature;

    TestData.Feature = Features(indTest,:);
    TestData.Labels = Labels(indTest,:);

    % Apply K-Fold Cross Validation
    K = 5;
    NT = numel(indTrain);
    CVI = crossvalind('kfold',NT,K);
    TrainData.CVI = CVI;
    TrainData.K = K;

end