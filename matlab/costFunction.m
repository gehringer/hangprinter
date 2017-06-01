function cost = costFunction(parameterArray, lineLengthsMeasured, calibrationPoints, unknownPoints, trueAnchors, absoluteLineLengthKnown, shouldPlot)
anchorsEstimated = array2anchors(parameterArray);

%prepare plot
if shouldPlot
    figure(4);
    clf
    axis equal
    view(3);
    hold on
    grid on
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    %plot true calibrationPoints
    plot3(calibrationPoints(1,:), calibrationPoints(2,:), calibrationPoints(3,:),'xr');
    plot3(unknownPoints(1,:), unknownPoints(2,:), unknownPoints(3,:),'xb');
    
end

%figure out absolute linelengths
if ~absoluteLineLengthKnown
    if size(calibrationPoints,2) > 0 %use first calibrationPoint for estimating absolute lengths
        lengthsMeasuredAtStart = lineLengthsMeasured(1,:);
        startLengths = cartesian2lineLengths(anchorsEstimated, calibrationPoints(:,1));
        lineLengthsMeasured = lineLengthsMeasured + repmat(startLengths - lengthsMeasuredAtStart,[size(lineLengthsMeasured,1) 1]);
        %remove from fitting data
        lineLengthsMeasured(1,:) = [];
        calibrationPoints(:,1) = [];
    else %startposition must also be estimated, it will be the last 3 elemtens in array
        %TODO
%         positionAtStart = parameterArray(end-3:end);
    end
else
    
end

%calculate cost
cost = 0;
for i = 1:size(lineLengthsMeasured,1)
    if i <= size(calibrationPoints,2) %known point
        lineLengthsExpected = cartesian2lineLengths(anchorsEstimated, calibrationPoints(:,i));
    else %unknown point
        moverBestFit = lineLengths2cartesian(anchorsEstimated, lineLengthsMeasured(i,:));
        lineLengthsExpected = cartesian2lineLengths(anchorsEstimated, moverBestFit);
        if shouldPlot
            %plot estimated position of unknown points
            plot3(moverBestFit(1), moverBestFit(2), moverBestFit(3),'ob');
        end
    end
    cost = cost + sum((lineLengthsMeasured(i,:) - lineLengthsExpected).^2);
end

    
%plot anchors
if shouldPlot    
    plot3(anchorsEstimated(1,:), anchorsEstimated(2,:), anchorsEstimated(3,:),'ok');
    plot3(trueAnchors(1,:), trueAnchors(2,:), trueAnchors(3,:),'xk');
    drawnow limitrate;
end
end