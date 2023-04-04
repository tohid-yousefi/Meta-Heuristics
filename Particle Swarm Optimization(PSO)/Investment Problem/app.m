%% Start of Program
clc;
clear;
close all;

%% Main App
Imax = 200;
I = 0:Imax;

P1 = @(I) 2*I;
P2 = @(I) (2.5*(I-20)).*(I>=20);
P3 = @(I) 120*min(I/10,1);
P4 = @(I) exp(0.03*I)-1;

%% Show Results
figure;
plot(I, P1(I), 'Color','b', 'LineWidth',2);
hold on
plot(I, P2(I), 'Color','r', 'LineWidth',2);
plot(I, P3(I), 'Color','g', 'LineWidth',2)
plot(I, P4(I), 'Color','c', 'LineWidth',2)


legend('P_1','P_2','P_3')
xlabel('I')
ylabel('P')