%% Start of Program
clc;
clear;
close all;

%% Loading Data
load DataSets\DataClassification.mat;

%% Select Kernel Function
KernelFunctions = {'linear','rbf','polynomial'};
KernelFunction = KernelFunctions{2};

%% Manage Data
[TrainData, TestData] = ManageData(data);
TrainData.KernelFunction = KernelFunction;

%% GOA Set Params
Params.nPop = 2;
Params.MaxIt = 20;

%% Optimize SVM uisng GOA
Results = OptimizeaSVMusingGOA(TrainData,Params);

%% Test Data Evaluation
Classify = Results.Out.Classify;
ClassTrain = predict(Classify,TestData.Feature);
CMT = confusionmat(TestData.Labels,ClassTrain);
AccuracyTest = sum(diag(CMT))/sum(CMT(:));

%% Display
disp('****************** Results ******************')
disp(['Train Accuracy      = ', num2str(100*mean(Results.Out.AccuracyTrain))])
disp(['Validation Accuracy = ', num2str(100*mean(Results.Out.AccuracyValid))])
disp(['Test Accuracy       = ', num2str(100*AccuracyTest)])
disp(['****************** KernelFunction ', KernelFunction, ' ******************'])
disp([Results.Out.SVMParams])
