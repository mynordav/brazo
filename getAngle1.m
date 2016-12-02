function angle1 = getAngle1(vBlue, vRed, vYellow)

pBlue = [vBlue(1) 0 vBlue(3)];
pRed = [vRed(1) 0 vRed(3)];
pYellow = [vYellow(1) 0 vYellow(3)];

pBlue = pBlue/norm(pBlue);
pRed = pRed/norm(pRed);
PYellow = pYellow/norm(pYellow);

pAvg = (pBlue+pRed+PYellow)/3;

refq1 = [1; 0; 0];

angle1 = acos(dot(pAvg,refq1)/(norm(pAvg)*norm(refq1)));

if pAvg(3) < 0
    angle1 = -angle1;
end

end