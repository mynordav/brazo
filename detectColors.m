%% Cargar imagen

i = 4;

load(['imagen',num2str(i),'.mat']);
    
img   = ptCloud.Color;
coord = ptCloud.Location;

%% Obtener coordenada del origen

thV = 0.21; thS = 0.4;  thH = 0.1;
hGreen = 120/360; 

imgGreen  = filterColor(img, hGreen,      thH, thS, thV);
imgGreenBW = imgGreen;
imgGreenBW(imgGreen > 0) = 1;
s = regionprops(imgGreenBW,'centroid');
centroids = cat(1, s.Centroid);

imshow(imgGreen)
hold on
plot(centroids(:,1),centroids(:,2), 'b*')
hold off

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

imgRed    = filterColor(img, hRed,        thH, thS, thV);
imgBlue   = filterColor(img, hBlue,   0.5*thH, thS, thV);
imgYellow = filterColor(img, hYellow,     thH, thS, thV);
imgPurple = filterColor(img, hPurple, 0.5*thH, thS, thV);


%% Detectar líneas y calcular vectores

[p1, p2] = lineDetect(imgPurple, 'Prewitt', 3, 40, 40);
tmp(:,1) = coord(p1(2), p1(1), :);
vPurple = vecFromPts(coord, p1, p2, tmp);

[p1, p2] = lineDetect(imgBlue,   'Prewitt', 3, 40, 40); 
[vBlue, pBlue2] = vecFromPts(coord, p1, p2, origin);

imshow(img);
hold on;
plot([p1(1), p2(1)],[p1(2), p2(2)],'LineWidth',2,'Color','green');

% Plot beginnings and ends of lines
plot(p1(1), p1(2),'x','LineWidth',2,'Color','yellow');
plot(p2(1), p2(2),'x','LineWidth',2,'Color','red');

[p1, p2] = lineDetect(imgRed,    'Prewitt', 3, 40, 40); 
[vRed, pRed2] = vecFromPts(coord, p1, p2, pBlue2);

[p1, p2] = lineDetect(imgYellow, 'Prewitt', 3, 40, 40); 
[vYellow, pYellow2] = vecFromPts(coord, p1, p2, pRed2);
finalPos = pYellow2;

origin(3) = origin(3) - baseRadius;
finalPos = finalPos - origin;
%% Get angles



%% Calcular ángulos

