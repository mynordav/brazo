%p1 and p2 must be 2 element columns
function [v, newLastPoint] = vecFromPts(ptCloudLoc, p1, p2, lastPoint)
    v1(:,1) = ptCloudLoc(p1(2), p1(1), :);
    v2(:,1) = ptCloudLoc(p2(2), p2(1), :);
    
    if norm(v2 - lastPoint) > norm(v1 - lastPoint)
        v = v2 - v1;
        newLastPoint = v2;
    else
        v = v1 - v2;
        newLastPoint = v1;
        %disp('hola')
    end
        v = v/norm(v);
end