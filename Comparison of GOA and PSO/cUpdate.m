%% Start of Prgram
clc;
clear;
close all;

%% C Update
MaxIt = 100;

xx = 1:MaxIt;
x = xx/MaxIt;

c = 1 - x*(1 - 0.00001);

figure(1);
plot(xx,c)

w = 0.5;
cNew = 0.00001 + (1 - x.^w).^(1/w)*(1 - 0.00001);

figure(2)
plot(xx,cNew)
