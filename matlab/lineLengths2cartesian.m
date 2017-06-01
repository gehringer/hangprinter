function [mover, steps] = lineLengths2cartesian(anchors, lineLengths)
%GaussNewton- uses the Gauss-Newton method to perform a non-linear least
%squares approximation for the origin of a circle of points
% Takes as input a row vector of x and y values, and a column vector of
% initial guesses. partial derivatives for the jacobian must entered below
% in the df function
tol = 1e-8; %set a value for the accuracy
maxstep = 30; %set maximum number of steps to run for
dimensions = 3;
numberOfAnchors = 4;

mover = [0; 0; 0]; %set initial guess for origin
moverOld = mover;
for k=1:maxstep %iterate through process
    S = 0;
    J = zeros(numberOfAnchors, dimensions);
    for i=1:numberOfAnchors %for each anchors
        J(i,:) = partialDerivative(anchors(:,i), mover); %calculate Jacobian
    end
    JT = J';
    Jz = -JT*J; %multiply Jacobian and
    %negative transpose
    for i=1:numberOfAnchors
        r(i,1) = lineLengths(i) - norm(mover-anchors(:,i));%calculate r
        S = S + r(i,1)^2; %calculate sum of squares of residuals
    end
    
    g = Jz\JT; %mulitply Jz inverse by J transpose
    mover = moverOld-g*r; %calculate new approximation
    err = mover(1,1)-moverOld(1,1); %calculate error
    if (abs(err) <= tol) %if less than tolerance break
        steps = k;
        break
    end
    moverOld = mover; %set moverOld to mover
end
end



