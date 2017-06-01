function lineLengthsMeasured = simulateSamples(calibrationPoints, anchorsTrue, noiseAmplitude)
numberOfCalibrationPoints = size(calibrationPoints,2);
numberOfLines = 4;
lineLengthsMeasured = zeros(numberOfCalibrationPoints, numberOfLines);
for i = 1:size(calibrationPoints,2)
    lineLengthsMeasured(i,:) = cartesian2lineLengths(anchorsTrue, calibrationPoints(:,i));
end
lineLengthNoise = noiseAmplitude*(random('Uniform',-1, 1,size(lineLengthsMeasured)));
lineLengthsMeasured = lineLengthsMeasured + lineLengthNoise;