function estimate = stochasticSolverTEST2D()
clear all
clc

generations = 100;
populationSize = 150;
min = [-1 -1];
max = [1 1];
actual = [0 0];%unifrnd(min,max);
costGain = 3;
costPower = 1;

% %individualsPlot
figure(2)
clf
view(3);
grid on
axis equal
axis([min(1) max(1) min(2) max(2) 0 1]);

% hold on

costFunc = @(param) costFunctionTEST(param, actual);
plotFuncIndividual = @(individual, color) plotFunctionIndividual(individual, color);
plotFuncGeneration = @(param) plotFunctionGeneration(actual, min, max);
tic
estimate = stochasticSolver(costFunc, plotFuncGeneration, plotFuncIndividual, min, max, generations, populationSize, costGain, costPower);
toc
end

function cost = costFunctionTEST(param, actual)
cost = param(1)*sin(3*param(1)) + param(2)*sin(3*param(2)) + 0.6*cos(15*param(2))-0.1;
cost = abs(cost);
if abs(param(1)) > 0.9  || abs(param(2)) > 0.9
    cost = cost + 0.5;
end
end

function plotFunctionIndividual(individual, color)
figure(2);
plot3(individual.param(1), individual.param(2), individual.cost, color);
end

function plotFunctionGeneration(actual, min, max)
figure(2);
cla
grid on
% view(2);
grid on
axis equal
axis([min(1) max(1) min(2) max(2) 0 1]);
hold on
x = linspace(min(1),max(1),30);
y = linspace(min(2),max(2),30);
[X,Y] = meshgrid(x,y);
Z = zeros(length(x), length(y));

for i = 1:length(x)
    for j = 1:length(y)
        Z(i,j) = costFunctionTEST([x(i) y(j)], actual);
    end
end
mesh(X,Y,Z);
% semilogy(x, y, '--r');
end