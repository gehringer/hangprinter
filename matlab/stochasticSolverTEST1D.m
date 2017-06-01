function stochasticSolverTEST1D()
clear all
clc

generations = 150;
populationSize = 100;
min = -1;
max = 1;
actual = unifrnd(min,max);
costGain = 2;
costPower = 0.5;

% %individualsPlot
% figure(2)
% clf
% hold on

costFunc = @(param) costFunctionTEST(param, actual);
plotFuncIndividual = @(individual, color) plotFunctionIndividual(individual, color);
plotFuncGeneration = @(param) plotFunctionGeneration(actual, min, max);
tic
estimate = stochasticSolver(costFunc, plotFuncGeneration, plotFuncIndividual, min, max, generations, populationSize, costGain, costPower);
toc
error = estimate - actual
end

function cost = costFunctionTEST(param, actual)
cost = (param - actual)^2;
end

function plotFunctionIndividual(individual, color)
figure(2);
semilogy(individual.param, individual.cost, color);
end

function plotFunctionGeneration(actual, min, max)
figure(2);
clf
axis([min max (10^-20) (10^1)]);
hold on
set(gca, 'YScale', 'log')
x = linspace(min,max);
for i = 1:length(x)
    y(i) = costFunctionTEST(x(i), actual);
end
semilogy(x, y, '--r');
end