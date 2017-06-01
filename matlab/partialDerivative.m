function deltaLineLengthDeltaMoverPos = partialDerivative(anchor, mover) %calculate partial derivatives for anchor
% mover: current mover estimate
% anchor: true anchor position
% deltaLineLengthDeltaMoverPos = dl/dmover, the elements, one for each x,
% y, z

deltaLineLengthDeltaMoverPos = [(mover(1) - anchor(1))/norm(mover-anchor),...
                                (mover(2) - anchor(2))/norm(mover-anchor),...
                                (mover(3) - anchor(3))/norm(mover-anchor)];
end