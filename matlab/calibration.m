function [anchorsEstimated, anchorErrorRMS] = calibration()
clear all
clc
clf

calibrationPoints = zeros(3,0);
unknownCalibrationPoints = zeros(3,0);
anchorsTrue = zeros(3,0);

% calibrationPoints = [0.15,  0.15, -0.15;
%                      0.15, -0.15,  0.15;
%                        0,    0,    0];
% calibrationPoints = [0; 0; 0];

%simulationParams
simulate = false;
randomSamples = true;
numberOfUnknownPoints = 10;
noiseAmplitude = 0.003;

%identificationParams
absoluteLineLengthKnown = false;
shouldPlot = false;
stochastic = true;

if simulate
    if randomSamples
        unknownCalibrationPoints = zeros(3,numberOfUnknownPoints);
        for i = 1:numberOfUnknownPoints
            unknownCalibrationPoints(:,i) = [0.5*(2*rand-1), 0.5*(2*rand-1), 0.7*rand]';
        end
    else
        unknownCalibrationPoints = [0.2,  0.15,  -0.3, -0.2,  -0.3, -0.25;
                                    0.0,   0.0, -0.15, -0.1,  0.15,   0.1;
                                    0,   0.4,     0,  0.4,     0,   0.4];
    end
    anchorsTrue = 0.001*[ 406, -608, -681,    0;
                            0,  287, -485,    0;
                            0,    0,    0, 1124];
    
    lineLengths = simulateSamples([calibrationPoints, unknownCalibrationPoints], anchorsTrue, noiseAmplitude);
else
%     calibrationPoints = [0.14; 0; 0];
    lineLengths = 0.001*[ 1435.46, 1464.74, 1704.02, 2295.00;
                          1703.08, 1213.52, 1552.01, 2295.00;
                          1813.98, 1236.02, 1316.49, 2295.00;
                          1893.27, 1327.70, 1155.76, 2295.00;
                          1778.12, 1621.78, 1003.01, 2295.00;
                          1670.70, 1823.98, 1054.38, 2295.00;
                          1466.86, 1850.16, 1246.16, 2295.00;
                          1216.75, 1892.86, 1508.48, 2295.00;
                          1113.20, 1848.52, 1680.55, 2295.00;
                          1453.65, 1566.52, 1355.35, 2295.00;
                          1359.13, 1936.83, 1768.89, 2017.87;
                          1419.37, 1844.27, 1857.94, 2017.87;
                          1661.11, 1458.37, 1724.85, 2017.87;
                          1915.19, 1313.23, 1591.31, 2017.87;
                          1986.60, 1450.64, 1292.30, 2017.87;
                          1875.09, 1693.54, 1145.18, 2017.87;
                          1537.95, 1609.22, 1422.88, 2017.87];
    
end

%find optimal anchors
large =2;
small =0.2;
arrayMin = [  small, -large, -large,  small, -large, small];
arrayMax = [  large, -small, -small,  large, -small, large];
%     arrayMin = [ -5,   -5,   -5,   -5,   -5,   1]';
%     arrayMax = [  5   , 5,    5,    5,    5,   4]';

costFunc = @(anchorArray) costFunction(anchorArray, lineLengths, calibrationPoints, unknownCalibrationPoints, anchorsTrue, absoluteLineLengthKnown, shouldPlot);
if stochastic
    plotFuncIndividual = @(individual, color) plotFunctionIndividual(individual, color);
    plotFuncGeneration = @(best) plotFunctionGeneration(best, anchorsTrue, calibrationPoints, unknownCalibrationPoints, arrayMin, arrayMax);

    generations = 1000;
    populationSize = 400;
    costGain = 10;
    costPower = 1;
    figure(1)
    clf
    hold on
    anchorArrayEstimate = stochasticSolver(costFunc, plotFuncGeneration, plotFuncIndividual, arrayMin, arrayMax, generations, populationSize, costGain, costPower);
else
%     anchorsFirstEstimate = [ 1, -1, -1, 0;
%                     0,  1, -1, 0;
%                     0,  0,  0, 2];
                
% anchorsFirstEstimate = [1.6739   -0.4355   -0.7335         0;
%                              0    1.4540   -0.5618         0;
%                              0         0         0    2.7686];
    anchorsFirstEstimate =  [1.5, -1.5, -1.5, 0;
                              0,  1.5, -1.5, 0;
                              0,  0,  0, 2];
    anchorArrayFirstEstimate = anchors2array(anchorsFirstEstimate);
    
    options = optimset('Display','iter','PlotFcns',@optimplotfval);
    tic
    anchorArrayEstimate = fminsearch(costFunc,anchorArrayFirstEstimate, options);
    toc
%     anchorArrayEstimate = fminsearch(costFunc,anchorArrayFirstEstimate);
end

anchorsEstimated = array2anchors(anchorArrayEstimate)
plotFunctionGeneration(anchorArrayEstimate, anchorsTrue, calibrationPoints, unknownCalibrationPoints, arrayMin, arrayMax)
if ~isempty(anchorsTrue)
    anchorErrorRMS = sqrt(sum(sum((anchorsTrue - anchorsEstimated).^2))/(size(anchorsTrue,1)*size(anchorsTrue,2)))
else
    anchorErrorRMS = 0;
end
end

function plotFunctionIndividual(individual, color)
% figure(3);
% plot3(individual.param(2), individual.param(4), individual.cost, color);
end

function plotFunctionGeneration(best, anchorsTrue, calibrationPoints, unknownCalibrationPoints, arrayMin, arrayMax)
% figure(3);
% clf
% % axis equal
% set(gca, 'ZScale', 'log');
% axis([arrayMin(2) arrayMax(2) arrayMin(4) arrayMax(4) (10^-4) (10^1)]);
% view(3);
% grid on
% xlabel('X');
% ylabel('Y');
% hold on

figure(2);
clf
axis equal
view(3);
grid on
xlabel('X');
ylabel('Y');
zlabel('Z');
hold on

anchorsEstimated = array2anchors(best);
plot3(calibrationPoints(1,:), calibrationPoints(2,:), calibrationPoints(3,:),'xr');
plot3(unknownCalibrationPoints(1,:), unknownCalibrationPoints(2,:), unknownCalibrationPoints(3,:),'xb');
plot3(anchorsEstimated(1,:), anchorsEstimated(2,:), anchorsEstimated(3,:),'ok');
plot3(anchorsTrue(1,:), anchorsTrue(2,:), anchorsTrue(3,:),'xk');
end