%p1 and p2 must be 2 element columns
function v = vecFromPts(ptCloudLoc, p1, p2)
    v1 = ptCloudLoc(p1(2), p1(1), :);
    v2 = ptCloudLoc(p2(2), p2(1), :);
    
    v = v2 - v1;
end