function [p,q] = detectColors(ptCloud)

img   = ptCloud.Color;
coord = ptCloud.Location;
hsvImg = rgb2hsv(img);
%% Obtener coordenada del origen

thV = 0.21; thS = 0.4;  thH = 0.1;
hGreen = 120/360; 



imgGreen  = filterColor(hsvImg, hGreen,      thH, thS, thV);
imgGreenBW = imgGreen;
imgGreenBW(imgGreen > 0) = 1;
s = regionprops(imgGreenBW,'centroid');
centroids = cat(1, s.Centroid);

baseRadius = 0.0775;
center = round([centroids(1), centroids(2)]);

origin = zeros(3,1);
origin(:,1) = coord(center(2), center(1), :);


%% Filtrar por color


thV = 0.25;
thS = 0.4;
thH = 0.1;

hRed   =   0/360;   hBlue   = 210/360;    hYellow = 60/360;
hPurple = 250/360;



imgRed    = filterColor(hsvImg, hRed,        thH, thS, thV);
imgBlue   = filterColor(hsvImg, hBlue,   0.5*thH, thS, thV);
imgYellow = filterColor(hsvImg, hYellow,     thH, thS, thV);
imgPurple = filterColor(hsvImg, hPurple, 0.5*thH, thS, thV);


%% Detectar líneas y calcular vectores

imshow(img); hold on

% [p1, p2] = lineDetect(imgPurple, 'Prewitt', 3, 40, 40);
% tmp(:,1) = coord(p1(2), p1(1), :);
% vPurple = vecFromPts(coord, p1, p2, tmp);

% plot([p1(1),p2(1)],[p1(2),p2(2)],'LineWidth',2,'Color','green');
% plot(p1(1),p1(2),'x','LineWidth',2,'Color','yellow');
% plot(p2(1),p2(2),'x','LineWidth',2,'Color','red');

[p1, p2] = lineDetect(imgBlue,   'Prewitt', 3, 40, 40); 
[vBlue, pBlue2] = vecFromPts(coord, p1, p2, origin);

plot([p1(1),p2(1)],[p1(2),p2(2)],'LineWidth',2,'Color','green');
plot(p1(1),p1(2),'x','LineWidth',2,'Color','yellow');
plot(p2(1),p2(2),'x','LineWidth',2,'Color','red');

[p1, p2] = lineDetect(imgRed,    'Prewitt', 3, 40, 40); 
[vRed, pRed2] = vecFromPts(coord, p1, p2, pBlue2);

plot([p1(1),p2(1)],[p1(2),p2(2)],'LineWidth',2,'Color','green');
plot(p1(1),p1(2),'x','LineWidth',2,'Color','yellow');
plot(p2(1),p2(2),'x','LineWidth',2,'Color','red');

[p1, p2] = lineDetect(imgYellow, 'Prewitt', 3, 40, 40); 
[vYellow, pYellow2] = vecFromPts(coord, p1, p2, pRed2);
finalPos = pYellow2;

plot([p1(1),p2(1)],[p1(2),p2(2)],'LineWidth',2,'Color','green');
plot(p1(1),p1(2),'x','LineWidth',2,'Color','yellow');
plot(p2(1),p2(2),'x','LineWidth',2,'Color','red');

%pause()

origin(3) = origin(3) - baseRadius;
finalPos = finalPos - origin;


%% Calcular ángulos  % Medio sirve, mejorarlo

% vec3Translate = origin;
% mat3RotX90 = rotx(90);
% mat3RotZ_90 = rotz(-90);
% 
K2B =  [ 0 1 0 0;
        0 0 -1 0;
       -1 0  0 0;
        0 0  0 1];


T = inv(K2B);

% vPurpleT = T*[vPurple; 0];
% refq1 = [0; 1; 0; 0];

angles(1) = getAngle1(vBlue, vRed, vYellow);
% if vPurpleT(1) > 0
%     angles(1) = -angles(1);
% end


L  = [0.10 0.115 0.108 0.049];

s1 = sin(angles(1)); c1 = cos(angles(1));

A_01 = [-s1, 0, c1,  0;
         c1, 0, s1,  0;
         0,  1,  0,  L(1);
         0,  0,  0,  1  ];

T = inv(A_01)*T;

vBlueT = T*[vBlue;0];

refq2 = [0; 1; 0; 0];

angles(2) = acos(dot(vBlueT,refq2)/(norm(vBlueT)*norm(refq2)));
if vBlueT(1) > 0
    angles(2) = -angles(2);
end

s2 = sin(angles(2)); c2 = cos(angles(2));


A_12 = [ s2, c2, 0,  -L(2)*s2;
        -c2, s2, 0,   L(2)*c2;
          0,  0, 1,         0;
          0,  0, 0,         1];
 
T= inv(A_12)*T;

vRedT = T*[vRed;0];

refq3 = [0; 1; 0; 0];

angles(3) = acos(dot(vRedT,refq3)/(norm(vRedT)*norm(refq3)));
if vRedT(1) > 0
    angles(3) = -angles(3);
end

s3 = sin(angles(3)); c3 = cos(angles(3));

A_23 = [ s3, c3, 0, -L(3)*s3;
        -c3, s3, 0,  L(3)*c3;
          0,  0, 1,        0;
          0,  0, 0,        1];  
T = inv(A_23)*T;

vYellowT = T*[vYellow;0];

refq4 = [-1; 0; 0; 0];

angles(4) = acos(dot(vYellowT,refq4)/(norm(vYellowT)*norm(refq4)));
if vYellowT(2) > 0
    angles(4) = -angles(4);
end

rad2deg(angles)


q = angles';
p = finalPos;
%imshow(img)

end