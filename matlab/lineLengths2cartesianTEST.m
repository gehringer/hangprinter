%% lineLengths2cartesianTEST
clc


anchors = 0.001*[0      287     -285    0; 
                 406    -608    -681    0;
                 26     26      26      1150];

mover = [0.7,0.3,0.5]'
lineLengths = cartesian2lineLengths(anchors, mover)
noise = [0.01, 0.01, -0.01, -0.01];
[mover2, steps] = lineLengths2cartesian(anchors, lineLengths + noise)
lineLengths2 = cartesian2lineLengths(anchors, mover2)
error = sum(abs(lineLengths - lineLengths2))

plotHangprinter(anchors, mover, 1, 'xk')
plotHangprinter(anchors, mover2, 2, 'xk')