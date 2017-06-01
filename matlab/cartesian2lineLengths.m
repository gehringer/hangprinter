function lineLengths = cartesian2lineLengths(anchors, mover)
%            A B C D
% anchors = [x x x x; 
%            y y y y;
%            z z z z]
% mover = [x,y,z]'
% lineLengths = [a, b, c, d]
lineLengths = [0, 0, 0, 0];
for i = 1:4
    lineLengths(i) = norm(anchors(:,i) - mover);
end

