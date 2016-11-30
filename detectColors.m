%% Cargar imagen

i = 4;

load(['imagen',num2str(i),'.mat']);
    
img   = ptCloud.Color;
coord = ptCloud.Location;

%% Obtener coordenada del origen

thV = 0.21; thS = 0.4;  thH = 0.1;
hGreen = 120/360; 

imgGreen  = filterColor(img, hGreen,      thH, thS, thV);
[nRows, ~] = size(imgGreen);
[center, radii] = imfindcircles(imgGreen, [5, 100]);
baseRadius = 0.0775;
center = round(center);

origin = zeros(3,1);
%origin(:,1) = coord(center(2), center(1), :);
%origin(3) = origin(3) - baseRadius;


%% Filtrar por color


thV = 0.25;
thS = 0.4;
thH = 0.1;

hRed   =   0/360;   hBlue   = 210/360;    hYellow = 60/360;
hPurple = 250/360;

imgRed    = filterColor(img, hRed,        thH, thS, thV);
imgBlue   = filterColor(img, hBlue,   0.5*thH, thS, thV);
imgYellow = filterColor(img, hYellow,     thH, thS, thV);
imgPurple = filterColor(img, hPurple, 0.5*thH, thS, thV);


%% Detectar líneas y calcular vectores

[p1, p2] = lineDetect(imgRed,    'Prewitt', 3, 40, 40); 
vRed = vecFromPts(coord, p1, p2);

[p1, p2] = lineDetect(imgBlue,   'Prewitt', 3, 40, 40); 
vBlue = vecFromPts(coord, p1, p2);

[p1, p2] = lineDetect(imgYellow, 'Prewitt', 3, 40, 40); 
vYellow = vecFromPts(coord, p1, p2);
finalPos = p2;

[p1, p2] = lineDetect(imgPurple, 'Prewitt', 3, 40, 40); 
vPurple = vecFromPts(coord, p1, p2);

%% Get angles
% getAnglesFromKinectPoints(vRed, vBlue, vYellow, vPurple, origin);

%% Calcular ángulos

O = origin;

K2B_ =  [ 0 1 0  O(1);
        0 0 -1 -O(2);
       -1 0  0 -O(3);
        0 0  0    1];

vec3Translate = origin;
mat3RotX90 = rotx(90);
mat3RotZ_90 = rotz(-90);


K2B = [mat3RotX90,  zeros(3,1);
           zeros(1,3),      1   ]; 
K2B = K2B*[mat3RotZ_90,  zeros(3,1);
           zeros(1,3),      1   ];


T = inv(K2B);

vPurpleT = T*[vPurple; 0];
refq1 = [0; 1; 0; 0];

angles(1) = acos(dot(vPurpleT,refq1)/(norm(vPurpleT)*norm(refq1)));
if vPurpleT(1) > 0
    angles(1) = -angles(1);
end


L  = [0.10 0.115 0.108 0.049];

s1 = sin(angles(1)); c1 = cos(angles(1));

A_01 = [-s1, 0, c1,  0;
         c1, 0, s1,  0;
         0,  1,  0,  L(1);
         0,  0,  0,  1  ];

T = T*inv(A_01);

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
 
T= T*inv(A_12);

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
T = T*inv(A_23);

vYellowT = T*[vYellow;0];

refq4 = [0; 1; 0; 0];

angles(4) = acos(dot(vYellowT,refq4)/(norm(vYellowT)*norm(refq4)));
if vYellowT(1) > 0
    angles(4) = -angles(4);
end

rad2deg(angles)
