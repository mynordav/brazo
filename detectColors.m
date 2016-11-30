%% Cargar imagen

i = 10;

load(['imagen',num2str(i),'.mat']);

while 1

    
img   = ptCloud.Color;
coord = ptCloud.Location;


%% Filtrar por color

thV = 0.25;
thS = 0.4;
thH = 0.1;

hRed   =   0/360;   hBlue   = 210/360;    hYellow = 60/360;
hGreen = 120/360;   hPurple = 250/360;

imgRed    = filterColor(img, hRed,        thH, thS, thV);
imgBlue   = filterColor(img, hBlue,   0.5*thH, thS, thV);
imgYellow = filterColor(img, hYellow,     thH, thS, thV);
imgGreen  = filterColor(img, hGreen,      thH, thS, thV);
imgPurple = filterColor(img, hPurple, 0.5*thH, thS, thV);


%% Detectar líneas y calcular vectores
tic
[p1, p2] = lineDetect(imgRed,    'Prewitt', 3, 40, 40); 
vRed = vecFromPts(coord, p1, p2);

[p1, p2] = lineDetect(imgBlue,   'Prewitt', 3, 40, 40); 
vBlue = vecFromPts(coord, p1, p2);

[p1, p2] = lineDetect(imgYellow, 'Prewitt', 3, 40, 40); 
vYellow = vecFromPts(coord, p1, p2);

[p1, p2] = lineDetect(imgPurple, 'Prewitt', 3, 40, 40); 
vPurple = vecFromPts(coord, p1, p2);

toc
end
