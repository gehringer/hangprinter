function bestParam = stochasticSolver(costFunc, plotFuncGeneration, plotFuncIndividual, paramMin, paramMax, generations, populationSize, costGain, costPower)
%costFunc is a cost function, expects a scalar cost returned.
%paramMax is a Nx1 matrix with max value for each param
%paramMin is a Nx1 matrix with minvalue for each param
%plotFuncGeneration is called once at each generation
%plotFuncIndividual is called for each individual's params at each generation


randomEvolvPerGeneration = round(0.05*populationSize);
randomPerGeneration = round(0.1*populationSize);
matingPerGeneration = round(0.05*populationSize);
populationToKeep = populationSize - randomEvolvPerGeneration - randomPerGeneration - matingPerGeneration;

%progress plot
figure(1)
clf
hold on
grid on
set(gca, 'YScale', 'log');
axis([0 generations (10^-20) (10^1)]);

% generate a´population and evaluate them
population =[];
for i = 1:populationSize
    individual = randomIndividual(costFunc, paramMin, paramMax);
    population = insertInPopulation(individual, population);
    plotFuncIndividual(population(i),'.b');
end

lowestCost = population(1).cost;

%progress plot
figure(1)
plot(0,lowestCost,'.b');

for generation = 1:generations
    
    %save the 20 best individuals
    bestPopulation = population(1:populationToKeep);
    
    %generate new population based on best individuals + random
    bestPopulationModifiedRandom = [];
    
    for i = 1: randomEvolvPerGeneration
%         parent = bestPopulation(ceil((rand*(populationToKeep^(1/3))).^3)); %pick lower numbers with higher probability
        parent = bestPopulation(randi(populationToKeep)); %pick lower numbers with higher probability
        individual =  childIndividual(costFunc, parent, paramMin, paramMax, costGain, costPower);
        bestPopulationModifiedRandom = insertInPopulation(individual, bestPopulationModifiedRandom);
    end
    
    
    %generate new population based on best individuals mated
    bestPopulationMatedRandom = [];
    for i = 1:matingPerGeneration
%         parent = bestPopulation(ceil((rand*(populationToKeep^(1/3))).^3)); %pick lower numbers with higher probability
        parentA = bestPopulation(randi(populationToKeep)); %pick lower numbers with higher probability
        parentB = bestPopulation(randi(populationToKeep)); %pick lower numbers with higher probability
        child = parentA;
        for j = 1:length(paramMax)
            if rand > 0.5
                child.param(j) = parentA.param(j);
            else
                child.param(j) = parentB.param(j);
            end            
        end
        individual =  childIndividual(costFunc, child, paramMin, paramMax, costGain, costPower);
        bestPopulationMatedRandom = insertInPopulation(individual, bestPopulationMatedRandom);
    end
    
    randomPopulation = [];
    for i = 1:randomPerGeneration % new random
        individual = randomIndividual(costFunc, paramMin, paramMax);
        randomPopulation = insertInPopulation(individual, randomPopulation);
    end
    
    
    %population plot
    plotFuncGeneration(bestPopulation(1).param);
    
    %plot bestPopulation
    for individual = bestPopulation
        plotFuncIndividual(individual,'.r');
    end
    
    %plot bestPopulationModifiedRandom
    for individual = bestPopulationModifiedRandom
        plotFuncIndividual(individual,'.g');
    end
    
    %plot randomPopulation
    for individual = randomPopulation
        plotFuncIndividual(individual,'.b');
    end
    
    %plot bestPopulationMatedRandom
    for individual = bestPopulationMatedRandom
        plotFuncIndividual(individual,'.k');
    end
    
    %merge different populations
    population = mergePopulations(bestPopulation,bestPopulationModifiedRandom);
    population = mergePopulations(population, randomPopulation);
    population = mergePopulations(population, bestPopulationMatedRandom);
    
    %progress plot
    figure(1)
    lowestCost = population(1).cost
    plot(generation,lowestCost,'.b');
    drawnow;
%     pause(0.3);
    
end
bestParam = population(1).param;
end


function individual = randomIndividual(costFunc, paramMin, paramMax)
individual.param = unifrnd(paramMin,paramMax);
individual.cost = costFunc(individual.param);
end

function individual = childIndividual(costFunc, parent, paramMin, paramMax, costGain, costPower)
noiseAmplitude = min(0.05, costGain*(parent.cost)^costPower);
noise = zeros(size(paramMin));
for i = 1:length(paramMin)
    if rand < 1/length(paramMin)
    noise(i) = noiseAmplitude*unifrnd(paramMin(i),paramMax(i));
    end
end

% noise = noiseAmplitude*unifrnd(paramMin,paramMax);

individual.param = parent.param + noise;
individual.cost = costFunc(individual.param);
end

function a = mergePopulations(a, b)
%a and b are populations
for n = 1:length(b)
    a = insertInPopulation(b(n), a);
end
end

function population = insertInPopulation(individual, population)
%todo binary search, but this is fast enough
if isempty(population)
    population = individual;
else
    if population(end).cost > individual.cost % should insert in population
        i = 1;
        while population(i).cost < individual.cost
            i= i+1;
        end
        population = [population(1:i-1) individual population(i:end)];
    else %append population
        population = [population individual];
    end
end
end

%doesnt work?
function population = insertInPopulationDERP(individual, population)
%binary search insert sort, lowest cost first
if isempty(population)
    population = individual;
else
    if population(end).cost > individual.cost % should insert in population
        i = 1;
        hi = length(population);
        lo = 1;
%         mid = floor((hi + lo)/2);
        while hi > (lo + 1)
            mid = floor((hi + lo)/2);
            if individual.cost > population(mid).cost
                lo=mid;
            else
                hi=mid;
            end            
        end
        population = [population(1:hi-1) individual population(hi:end)];
    else %append population
        population = [population individual];
    end
end
end