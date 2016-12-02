function [p1, p2] = lineDetect(imgIn, filter, nLines, fillGap, minLength)
    edg = edge(imgIn,filter, 'nothinning');
    [H, th, rho] = hough(edg);
    peaks = houghpeaks(H, nLines);
    lines = houghlines(edg, th, rho, peaks,'FillGap',fillGap,'MinLength',minLength);
    
    %Average lines
    x1 = 0; x2 = 0; y1 = 0; y2 = 0;
    for k = 1:length(lines)
       x1 = x1 + lines(k).point1(1);
       x2 = x2 + lines(k).point2(1);
       y1 = y1 + lines(k).point1(2);
       y2 = y2 + lines(k).point2(2);
    end
    
    x1 = x1/k;  x2 = x2/k; y1 = y1/k;   y2 = y2/k;
    p1 = [round(x1); round(y1)];
    p2 = [round(x2); round(y2)];
    
end