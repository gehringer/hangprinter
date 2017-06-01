function plotHangprinter(anchors, mover, figNumber, anchorColors)
%            A B C D
% anchors = [x x x x; 
%            y y y y;
%            z z z z]

% mover = [x, y, z]'

figure(figNumber);
% cla
axis equal
view(3);
hold on
grid on
xlabel('X');
ylabel('Y');
zlabel('Z');

for i = 1:size(anchors,2)
    %plot anchors
    plot3(anchors(1,i), anchors(2,i), anchors(3,i),anchorColors);
    
    %plot lines
    plot3([anchors(1,i), mover(1)],[anchors(2,i), mover(2)],[anchors(3,i), mover(3)],'g');    
end

%plot mover
plot3(mover(1), mover(2), mover(3),'xr');
