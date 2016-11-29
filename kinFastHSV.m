% Fecha: 26 - Nov - 2016
 % Modificaciones: Mismo Codigo, pero con funciones
 %%
 % clear
 % close all
 % clc
 % imaqreset;
 % 
 % colorVid = imaq.VideoDevice('kinect',1);
 % depthVid = imaq.VideoDevice('kinect',2);
 % step(colorVid);
 % step(depthVid);
 %%
 
 close all
 clc
 

C1 = 0;
C2 = 60/360;
C3 = 210/360;
C4 = 140/360;
C5 = 255/360;
C = struct('R', uint8(30), 'G', uint8(70),   'B',  uint8(35),  'TH', uint8(10)); % Origen 
 
 efec_fin = struct('x1', 0, 'x2', 0, 'y1', 0, 'y2', 0, 'z1', 0, 'z2', 0);
 seg_es   = struct('x1', 0, 'x2', 0, 'y1', 0, 'y2', 0, 'z1', 0, 'z2', 0);
 prim_es  = struct('x1', 0, 'x2', 0, 'y1', 0, 'y2', 0, 'z1', 0, 'z2', 0);
 
 
 while(1)
 tic
 
 try
     colorImage = step(colorVid);
     depthImage = step(depthVid);
     ptCloud = pcfromkinect(depthVid, depthImage,colorImage);

     %% Get Origin

     %center = colorFilter(colorImage,C4);
     %[col, row] = getCoordinates(center, 1080);
     
     center = find((colorImage(:,:,1) > (C.R - C.TH) & colorImage(:,:,1) < (C.R + C.TH) ...
                  & colorImage(:,:,2) > (C.G - C.TH) & colorImage(:,:,2) < (C.G + C.TH)...
                  & colorImage(:,:,3) > (C.B - C.TH) & colorImage(:,:,3) < (C.B + C.TH) ));

     [col, row] = getCoordinates(center, 1080);

     %% Color Filters

     %Final Efector
     ba = colorFilter(colorImage, C2);
     %Second Efector
     br_V = colorFilter(colorImage, C1);
     %Third Efector
     ba_A = colorFilter(colorImage, C3);
     %Base
     ba_B = colorFilter(colorImage, C4);

     %% compute Hough Transforms
     tic
     figure(1), imshow(colorImage), hold on

     avg = getHoughTransform(ba, 300, 50, 'MAX');
     efecFin = avg;
     plot(efecFin(:,1),efecFin(:,2),'LineWidth',2,'Color','yellow');

     avg = getHoughTransform(br_V, 400, 70, 'MAX');
     segundo_eslabon = avg;
     plot(segundo_eslabon(:,1),segundo_eslabon(:,2),'LineWidth',2,'Color','red');

     avg = getHoughTransform(ba_A, 300, 50, 'AVG');
     tercer_eslabon = avg;
     plot(tercer_eslabon(:,1),tercer_eslabon(:,2),'LineWidth',2,'Color','blue');
     


     %Plotting the center
     plot(col, row,'xr:', 'MarkerSize', 15)

     x_dim = flipdim(ptCloud.Location(:,:,1),2);
     y_dim = flipdim(ptCloud.Location(:,:,2),2);
     z_dim = flipdim(ptCloud.Location(:,:,3),2);

     %% Getting each pair of x,y,z points fo each 'Eslabon'
     % Origin
     origin = [x_dim(row, col) y_dim(row, col) (z_dim(row, col) - 0.0775)];

     % Final Efector point coordinates
     efec_fin.x1 = x_dim(efecFin(3), efecFin(1));
     efec_fin.x2 = x_dim(efecFin(4), efecFin(2));

     efec_fin.y1 = y_dim(efecFin(3), efecFin(1));
     efec_fin.y2 = y_dim(efecFin(4), efecFin(2));

     efec_fin.z1 = z_dim(efecFin(3), efecFin(1));
     efec_fin.z2 = z_dim(efecFin(4), efecFin(2));

     % Second 'Eslabon' point coordinates
     seg_es.x1 = x_dim(segundo_eslabon(3), segundo_eslabon(1));
     seg_es.x2 = x_dim(segundo_eslabon(4), segundo_eslabon(2));

     seg_es.y1 = y_dim(segundo_eslabon(3), segundo_eslabon(1));
     seg_es.y2 = y_dim(segundo_eslabon(4), segundo_eslabon(2));

     seg_es.z1 = z_dim(segundo_eslabon(3), segundo_eslabon(1));
     seg_es.z2 = z_dim(segundo_eslabon(4), segundo_eslabon(2));

     % Third 'Eslabon' point coordinates
     prim_es.x1 = x_dim(tercer_eslabon(3), tercer_eslabon(1));
     prim_es.x2 = x_dim(tercer_eslabon(4), tercer_eslabon(2));

     prim_es.y1 = y_dim(tercer_eslabon(3), tercer_eslabon(1));
     prim_es.y2 = y_dim(tercer_eslabon(4), tercer_eslabon(2));

     prim_es.z1 = z_dim(tercer_eslabon(3), tercer_eslabon(1));
     prim_es.z2 = z_dim(tercer_eslabon(4), tercer_eslabon(2));

    a1 = [efec_fin.x1 efec_fin.y1 efec_fin.z1];
    a2 = [efec_fin.x2 efec_fin.y2 efec_fin.z2];

    b1 = [seg_es.x1 seg_es.y1 seg_es.z1];
    b2 = [seg_es.x2 seg_es.y2 seg_es.z2];

    c1 = [prim_es.x1 prim_es.y1 prim_es.z1];
    c2 = [prim_es.x2 prim_es.y2 prim_es.z2];

    center = origin;
    ef_finalPos = efec_fin.x1;
    line_1 = a1 - a2;
    line_2 = b1 - b2;
    line_3 = c1 - c2;
    
    totalTime = toc
 catch
     disp('Error')
 end
     
 
 %while END!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
 end
 
 
 function [c, f] = getCoordinates(a,rows)
     c = ceil(a./rows);
     f = a - (rows*(c - 1));
     
     c = round(mean(c));
     f = round(mean(f));
 end
 
 
 function band = colorFilter(colorImage, Hue)
    imageHSV = rgb2hsv(colorImage);
     
    H = imageHSV(:,:,1);
    S = imageHSV(:,:,2);
    V = imageHSV(:,:,3);

    filtro = H - Hue;
   %filtro = ~(abs(filtro) < 0.08);
    
    V(S<0.5) = 0;
    V(V<0.3) = 0;
    V(~(abs(filtro) < 0.08)) = 0;
    
    imageHSV(:,:,1) = H;
    imageHSV(:,:,2) = S;
    imageHSV(:,:,3) = V;
    
    %imshow(hsv2rgb(imageHSV));
    band = rgb2gray(hsv2rgb(imageHSV));
    
 end
 
 
 function avg = getHoughTransform(band, FillGap, MinLength, type)
 BW_A = edge(band,'Prewitt');
 
 [H,theta,rho] = hough(BW_A);
 P = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));
 lines = houghlines(BW_A,theta,rho,P,'FillGap',FillGap,'MinLength',MinLength);
 max_len = 0;
 p1_avg = 0;
 p2_avg = 0;
 avg = 0;
     for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
     %    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
         p1_avg = p1_avg + lines(k).point1;
         p2_avg = p2_avg + lines(k).point2;
 
 
     %    Plot beginnings and ends of lines
     %    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
     %    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
        % Determine the endpoints of the longest line segment
        len = norm(lines(k).point1 - lines(k).point2);
        if ( len > max_len)
           max_len = len;
           xy_long = xy;
        end
     end
     % highlight the longest line segment
     p1_avg = round(p1_avg/length(lines));
     p2_avg = round(p2_avg/length(lines));
     
     switch type
         case 'AVG'
             avg = [p1_avg; p2_avg];
         case 'MAX'
             avg = xy_long;
     end
 end